require_relative 'mechanize_agent'
require 'chronic'

Job = Struct.new(:title, :job_id, :company, :company_id, :posting_link, 
                 :location, :posting_date )

class JobDetails

  def initialize(posting_urls)
    @posting_urls = posting_urls
    @agent = DiceMech.new
    @jobs = []
  end


  def get_details
    @posting_urls.each do |url|
      puts "Working on post URL ending ... #{url[33..-1]}\n"
      
      job_page = get_job_page(url)

      # job_page will be nil if there were any errors
      unless job_page.nil?
        job = Job.new

        job.title = job_page.search("h1.jobTitle").text
        job.company = job_page.link_with(:href => /company/).text
        job.posting_link = url
        job.location = job_page.search("li.location").text

        # Need to trim up some text from Job and Company IDs
        raw_job_id = job_page.search('div.company-header-info').search('div:contains("Position Id")')[-1].text
        job.job_id = trim_job_id(raw_job_id)

        raw_company_id = job_page.search('div.company-header-info').search('div:contains("Dice Id")')[-1].text
        job.company_id = trim_company_id(raw_company_id)

        # Turn Dice posting dates like "2 weeks ago" into real dates
        posting_date = job_page.search("li.posted").text
        job.posting_date = get_real_date(posting_date)

        @jobs << job
      end

    end

    @jobs
  end


  def get_job_page(url)
    begin
      @agent.get(url)
    rescue => error
      puts "Error getting job page: #{error}"
    end
  end


  def trim_job_id(raw_job_id)
    raw_job_id.slice!("Position Id : ")
    raw_job_id
  end


  def trim_company_id(raw_company_id)
    raw_company_id.slice!("Dice Id : ")
    raw_company_id
  end


  def get_real_date(posting_date)
    if posting_date == "Posted Moments Ago"
      Time.now.strftime("%F")
    else
      begin
        posting_date.slice!("Posted ")
        Chronic.parse(posting_date).strftime("%F")
      rescue
        return "Error parsing posting date"
      end
    end
  end
  
end