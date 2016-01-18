require 'pp'
require 'mechanize'
require 'byebug'
require 'chronic'
require 'csv'
require_relative 'job'

class DiceScraper

  attr_reader :jobs

  ID_REGEX = /\/([^\/]+)\/([^\/]+?)\?icid/

  def initialize
    @agent = Mechanize.new do |agent|
      agent.user_agent_alias = "Mac Safari"
      agent.history_added = Proc.new { sleep 0.5 }
    end
    @jobs = []
  end

  def search_for(query)
    query = query.split(" ").join("+")
    search_page(query)
  end

  def search_page(query, page = 1)
    @agent.get("https://www.dice.com/jobs/q-#{query}-limit-120-startPage-#{page}-limit-120-jobs")
  end

  def scrape_jobs(query, date=nil)
    page = search_for(query)
    count = 1
    until error_page?(page)
      puts "Searching page # #{count}"
      job_nodes = get_job_nodes(page)
      job_nodes.each do |job_node|
        new_job = job_from_node(job_node)
        if date
          @jobs << new_job if new_job.date > date
        else
          @jobs << new_job
        end
      end
      count += 1
      page = search_page(query, count)
    end
  end

  def error_page?(page)
    page = @agent.get(page)
    !!page.at(".err_p")
  end

  def get_job_nodes(page)
    page.css(".col-md-9 > #serp > .serp-result-content")
  end

  def job_from_node(job_node)
    title = job_node.at("h3 a").attributes["title"].value # job title
    company = job_node.at(".employer .hidden-md a").text # company name
    link = job_node.at("h3 a").attributes["href"].value # link to posting on dice
    location = job_node.at(".location").text # location
    date = Chronic.parse(job_node.at(".posted").text) # date of posting
    matches = link.match(ID_REGEX)
    if matches
      company_id, job_id = matches.captures
    else
      raise "Can't find job_id or company_id in #{link}"
    end
    Job.new(title: title, company: company, link: link, location: location, date: date, company_id: company_id, job_id: job_id)
  end

  def save_to_csv
    headers = ['Title', 'Company', 'Link', 'Location', 'Date', 'Company Id', 'Job Id']

    unless File.exist?('scraped_jobs.csv')
      CSV.open("scraped_jobs.csv", 'w') do |csv|
        csv << headers
      end
    end

    CSV.open("scraped_jobs.csv", 'a') do |csv|
      @jobs.each do |job|
        csv << job.to_a
      end
    end
  end
end

scraper = DiceScraper.new
scraper.scrape_jobs("Javascript", Time.now-(60*60*24))
scraper.save_to_csv