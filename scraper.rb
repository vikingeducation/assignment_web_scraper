require 'rubygems'
require 'bundler/setup'
require 'mechanize'

# create a scraper that performs a search query and returns the first results page

Job = Struct.new(:title, :company_name, :link, :location, :post_date, :company_id, :id)

class Scraper

  attr_reader :keyword, :location, :jobs

  def initialize(keyword, location)
    raise ArgumentError unless keyword.is_a?(String) && location.is_a?(String)
    @keyword = keyword
    @location = location
    @jobs = []
    run
  end

  def run 
    scraper = Mechanize.new
    url = build_url.new_url
    page = scraper.get(url)

    [page.links_with(:class => 'dice-btn-link')[12]].each do |link| ### TEMPORARY
      post_page = link.click # click on the link
      @jobs << get_job(post_page, link)
    end

    scraper.history_added = Proc.new { sleep 0.5 }
  end

  def build_url 
    URLBuilder.new("https://www.dice.com/jobs?", q: @keyword, l: @location)
  end

  def get_job(post_page, link)
    job = Job.new
    job.title = post_page.search("h1.jobTitle").text
    job.company_name = post_page.search("li.employer a.dice-btn-link").text
    job.link = link.href
    job.location = post_page.search("li.location").text

    date_regex = /\d*\-\d*\-\d*/
    title = post_page.title
    date = title.match(date_regex)[0]
    job.post_date = date


    dice_regex = /[^Dice Id : ]\d*/
    dice_id = post_page.search('div.company-header-info div.col-md-12')[1].text   
    job.company_id = dice_id.match(dice_regex)[0]

    position_regex = /[^Position Id : ]\w*/
    position_id = post_page.search('div.company-header-info div.col-md-12')[2].text 
    job.id = position_id.match(position_regex)[0]

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

