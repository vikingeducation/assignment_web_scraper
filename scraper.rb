require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'nokogiri'
require 'pp'
require 'csv' 

class DiceScraper

  def initialize( address = "https://www.dice.com/jobs?q=ruby&l=San+Jose" )
    @address = address
  end

# address = "https://www.dice.com/jobs?q=ruby&l=San+Jose%2C+CA"

  def convert_to_date( posted )
    now_time = Time.now.to_i
    posted_array = posted.split(" ")
    num = posted_array[0].to_i
    units = posted_array[1]

    case units
    when "hour",  "hours" 
      difference = num * 3600
      posted_time = now_time - difference
    when "day",  "days"
      difference = num * 3600 * 24
      posted_time = now_time - difference
    when  "week", "weeks"
      difference = num * 3600 * 24 * 7
      posted_time = now_time - difference
    when "month", "months"
      difference = num * 3600 * 24 * 30
      posted_time = now_time - difference
    when "year", "years"
      difference = num * 3600 * 24 * 365
      posted_time = now_time - difference
    else
      posted_time = now_time
    end

    posted_time
  end


  def scrape
    agent = Mechanize.new
    page = agent.get(@address)

    jobs = page.search(".col-md-9 > #serp > .serp-result-content")
    CSV.open('dice_job.csv', 'w') do |csv|
      
      jobs.each do |job|
        title = job.at("h3 a").attributes["title"].value # job title
        location = job.at(".location").text # location
        company = job.at("ul li span a").text # location
        link = job.at("h3 a").attributes["href"].value
        posted =  job.at(".posted").text
        posted_date = Time.at( convert_to_date( posted )).strftime "%Y-%m-%d"

        company_id_link = job.at(".dice-btn-link").attributes["href"].value
        company_id, job_id = "", ""
        if company_id_link.include? "detail"
          job_id =  company_id_link.split("/")[7].split("?").first
          company_id = company_id_link.split("/")[6]
        end

        csv << [ title, location, company, posted_date, company_id, job_id, link ]
      end
    end
  
  end
end

scraper = DiceScraper.new
scraper.scrape

