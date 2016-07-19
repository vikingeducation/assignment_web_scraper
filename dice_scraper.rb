require 'rubygems'
require 'bundler/setup'
require 'mechanize'

JobListing = Struct.new(:title, :company, :link, :location, :date, :company_id, :job_id)

class JobSearcher

  attr_reader :job_page

  def initialize(position, location)
    @position = position
    @location = location
    @agent = Mechanize.new
    @job_page = @agent.get("https://www.dice.com/jobs?q=#{p_update}&l=#{l_update}")
  end

  def p_update
    @position.gsub(" ", "+")
  end

  def l_update
    @location.gsub(",", "%2C")
    @location.gsub(" ", "+")
  end

  def get_url(page_number)
    url = @job_page.uri.to_s + "&startPage=#{page_number}"
  end

  def get_all_links
    current_page = @job_page
    jobs = []
    page_number = 1
    until current_page.body.include?("404 - The page you're looking for couldn't be found or it may have expired.")

      jobs += current_page.links_with(:href => /jobs\/detail/)
      page_number += 1
      current_page = @agent.get(get_url(page_number))
    end
    jobs
  end

  def get_all_urls
    urls = []
    get_all_links.each do |link|
      urls << link.uri.to_s
    end
    urls.uniq.length
  end

  def create_listings
    listings_array = []
    get_all_urls.each do |url|
      @agent.get(url)

    end
  end

end

j = JobSearcher.new("Software Engineer", "Boise, ID")
#p j.get_jobs_page.uri.to_s
# p p.get_all_jobs

p j.get_all_urls
