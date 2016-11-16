require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

Job = Struct.new(:title, :company, :location, :date, :company_id, :post_id, :url)

class Dice < Mechanize

  include FileTest
  
  def initialize(terms, location="", number = 10)
    @agent = Mechanize.new
    run(terms, location)
    @number = number
  end

  def run(terms, location)
    @agent.history_added = Proc.new { sleep 1.0 }
    results = get_jerbs(terms, location)
    csv_writer(results)
  end

  def get_jerbs(terms, location)
    jobs = []
    @agent.get("https://www.dice.com/jobs?q=#{terms}&l=#{location}&limit=#{@number}") do |page|
      page.links_with(:id => /position/).each do |link|
        node = make_job(link)
        jobs << node
      end # links_with
    end # agent
    jobs
  end # get_page method

  def make_job(link)
    done = false #used to grab only alternate links
    unless done
      #the most awesome process
      current_job = Job.new
      current_job.url = link.href
      current_job.title = link.text.strip

      job_page = link.click
      current_job.company = get_company(job_page)
      current_job.location = get_location(job_page)
      current_job.date = get_date(job_page)
      current_job.company_id = get_company_id(link)
      current_job.post_id = get_post_id(link)
      done = true
    else
      done = false
    end # unless
    current_job
  end

  def get_company(job_page)
    job_page.search('li.employer>a').children[0].text
  end

  def get_location(job_page)
    job_page.search('li.location').children[0].text
  end

  def get_date(job_page)
    job_page.search('title').children[0].text.split(" ")[-3]
  end

  def get_company_id(link)
    link.href.split("/")[6]
  end

  def get_post_id(link)
    link.href.split("/")[7].split("?")[0]
  end


  def csv_writer(results)
    input = convert_struct(results)
    unless FileTest.exist?('jobs.csv')
      CSV.open('jobs.csv', 'w+') do |csv|
        csv << ["Job Title", "Company", "Location", "Date Posted", "Company ID", "Post ID", "URL"]
      end
    end
    CSV.open('jobs.csv', 'a+') do |csv|
      input.each do |row|
        csv << row
      end
    end
  end

  def convert_struct(results)
    results_array = []

    results.each_with_index do |struct|
      results_row = []
      struct.each do |item|
        results_row << item
      end
      results_array << results_row
    end

    results_array
  end
end
