require_relative "scraper_ui.rb"
require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'pry'
require 'chronic'
require 'date'
# :date, :company_id, :job_id
Job = Struct.new(:title, :company, :link, :location, :date, :company_id, :job_id)  do
  def to_s
    str = "#{title} - #{company} - #{location}"
  end
end

class Scraper
  def initialize(scraper_ui)
    @url = scraper_ui.url
    @agent = Mechanize.new
    @agent.history_added = Proc.new { sleep 0.5 }
    @cutoff_date = scraper_ui.cutoff_date
  end

  def job_pages
    jobs = []
    page = @agent.get(@url)
    total_jobs = page.search('h4.posiCount span').last.text.to_i
    puts "total_jobs #{total_jobs}"
    num_pages = total_jobs/29 + 1

    (1..num_pages).each do |num|
      url = @url.gsub(/startPage.*-/,"startPage-#{num}-")
      num == num_pages ? num_jobs = total_jobs%29 - 1 : num_jobs = 30
      jobs << jobs(url, num_jobs)
    end
    jobs.flatten
  end

  def jobs(url, num_jobs)
    page = @agent.get(url)
    titles = []
    links = []
    company_ids = []
    job_ids = []
    jobs = []
    page.search('h3 a').each_slice(num_jobs).to_a[0].each do |i|
      titles << i.attributes["title"].value
      links << i.attributes["href"].value
      ids = /\/(.*)\/(.*)\?/.match(i.attributes["href"].value)
      unless ids.nil?
        company_ids << ids[1]
        job_ids << ids[2]
      end
    end
    companies = page.search('li.employer').each_slice(num_jobs).to_a[0].map { |c| c.children[4].children[0].text }
    locations = page.search('li.location').each_slice(num_jobs).to_a[0].map { |l| l.text }


    dates = page.search('li.posted').each_slice(num_jobs).to_a[0].map { |d| Chronic.parse(d.text) }
    titles.each_with_index do |title, i|
      unless @cutoff_date.nil?
        compare_dates = dates[i].to_date <=> @cutoff_date
        next if compare_dates < 0
      end
      jobs << Job.new(title, companies[i], links[i] ,locations[i], dates[i], company_ids[i], job_ids[i])
    end
    puts jobs
    jobs
  end
end

# jobs = ScraperUI.new
# jobs.search({q: 'ruby'}, nil)
# scraper = Scraper.new(jobs)
# scraper.jobs