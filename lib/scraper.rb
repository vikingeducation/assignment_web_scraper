require 'rubygems'
require 'mechanize'
require 'bundler/setup'
require_relative 'job'


class Scraper
  SEO = /<title>(\w.*?)\|/

  attr_accessor :job_array

  def initialize
    # @job_array = []
    run
  end

  def run

  agent = Mechanize.new
  agent.history_added = Proc.new { sleep 0.5 }

  page = agent.get('https://www.dice.com/jobs/q-web_development-jtype-Full+Time-sort-date-limit-30-l-San_Francisco%2C_CA-radius-10-jobs.html?searchid=6756117910756')



  page.links_with(:href => /www.dice.com\/jobs\/detail\//).each do |page_link|
     

    current_job = Job.new
    job_listing = page_link.click
    p current_job.page_link = page_link.uri.to_s
    # @job_array << current_job




    seo_tags = job_listing.title.split(" - ")
    # # [Job Title, Company, City and State, Date]
    p current_job.job_title =    seo_tags[0]
    p current_job.company_name = seo_tags[1]
    p current_job.location =     seo_tags[2]
    p current_job.date =         (seo_tags[3]).gsub(" | Dice.com", "")
    p current_job.page_link
    # pp current_job
    puts
    
  end
end



end

Scraper.new