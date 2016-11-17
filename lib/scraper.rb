require 'rubygems'
require 'bundler/setup'
require 'mechanize'

require_relative 'job'
require_relative 'url_builder'
require_relative 'csv_saver'

# create a scraper that performs a search query and returns the first results page

class Scraper

  attr_reader :keyword, :location, :jobs

  def initialize(keyword, location)
    raise ArgumentError unless keyword.is_a?(String) && location.is_a?(String)
    @keyword = keyword
    @location = location
    @jobs = []
    @links = []
  end

  def get_jobs
    scraper = Mechanize.new
    scraper.history_added = Proc.new { sleep 0.5 }
    url = build_url
    page = scraper.get(url)
    find_job_posts(page)
    @jobs 
  end

  def build_url 
    search = URLBuilder.new("https://www.dice.com/jobs?", q: @keyword, l: @location)
    search.url
  end

  def find_job_posts(page)
    page.links_with(:href => /detail/).each do |link|
      next if @links.include?(link.href)
      @links << link.href
      post = link.click
      @jobs << get_job_data(post, link)
    end
  end

  def get_job_data(post, link)
    job = Job.new 
    job.title = post.search("h1.jobTitle").text
    job.company_name = post.search("li.employer a.dice-btn-link").text
    job.link = link.href
    job.location = post.search("li.location").text
    job.post_date = post.search("li.posted").text
    job
  end

end


