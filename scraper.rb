require 'rubygems'
require 'bundler/setup'
require 'mechanize'

# create a scraper that performs a search query and returns the first results page

Job = Struct.new(:title, :company_name, :link, :location, :post_date, :company_id, :id)

class Scraper

  attr_accessor :jobs

  def initialize(job, location)
    raise ArgumentError unless job.is_a?(String) && location.is_a?(String)
    @jobs = []
  end

  def run 
    scraper = Mechanize.new
    url = build_url(job, location).new_url
    page = scraper.get(url)

    [page.links_with(:class => 'dice-btn-link')[12]].each do |link| ### TEMPORARY
      post_page = link.click # click on the link
      @jobs << get_job(post_page)
    end

    scraper.history_added = Proc.new { sleep 0.5 }
  end

  def build_url(job, location) 
    URLBuilder.new("https://www.dice.com/jobs?", q: job, l: location)
  end

  def get_job(post_page)
    job = Job.new
    job.title = post_page.search("h1.jobTitle").text
    job.company_name = post_page.search("li.employer a.dice-btn-link").text
    # job.link = post_page.uri
    job
  end

end

class URLBuilder 

  attr_reader :new_url 

  def initialize(url, parameters = {}) 
    @new_url = build_url(url, parameters)
  end

  def build_url(url, parameters)
    string = url 

    parameters.each do |key, value|
      key = key.to_s.gsub(/\s/, "+")
      value = value.gsub(/\s/, "+")
      string += key.to_s + "=" + value + "&"
    end

    string
  end

end

s = Scraper.new("developer", "philadelphia")

# PSEUDOCODE

# Find all items with class dice-btn-link 
# Click on link for each 

