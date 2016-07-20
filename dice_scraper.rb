require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'time'
require 'csv'

UNITS_TO_SECONDS = { minutes: 60,
                    hours: 3600,
                    days: 3600*24,
                    weeks: 3600*24*7,
                    months: 3600*24*30,
                    years: 3600*24*365 }

class DiceScraper

  attr_reader :job_page

  def initialize(query, location)
    @query = query
    @location = location
    @agent = Mechanize.new
    #@agent.history_added = Proc.new {sleep 0.5}
    @job_page = @agent.get("https://www.dice.com/jobs?q=#{query_to_url}&l=#{location_to_url}")
  end

  def create_csv(file_name)
    puts "Please wait while scraping...."
    CSV.open(file_name, 'w') do |csv|
      csv << ["Title", "Company", "Link", "Location", "Date", "Dice ID", "Position ID"]
      create_listings_array.each  {|listing| csv << listing}
    end
    puts "Your csv has been saved to #{file_name}."
  end

  private

  def query_to_url
    @query.gsub(" ", "+")
  end

  def location_to_url
    @location.gsub(",", "%2C").gsub(" ", "+")
  end

  def get_all_links
    current_page = @job_page
    job_links = []
    page_number = 1
    until current_page.body.include?("404 - The page you're looking for couldn't be found or it may have expired.")
      job_links += current_page.links_with(:href => /jobs\/detail/)
      page_number += 1
      current_page = @agent.get(get_other_pages(page_number))
    end
    job_links.uniq { |job_link| job_link.uri }
  end

  def get_other_pages(page_number)
    url = @job_page.uri.to_s + "&startPage=#{page_number}"
  end

  def create_listings_array
    listings_array = []
    get_all_links.each_with_index do |link, i|
      puts "Scraped #{i + 1} link(s)"
      current_page = link.click
      listings_array << [ title(current_page),
                          company(current_page),
                          link(current_page),
                          location(current_page),
                          date(current_page),
                          id(current_page, "Dice"),
                          id(current_page, "Position")]
    end
    listings_array
  end

  def title(page)
    return "" unless page.search("h1.jobTitle")
    page.search("h1.jobTitle").text
  end

  def company(page)
    return "" unless page.search("li.employer a")
    page.search("li.employer a").text
  end

  def link(page)
    return "" unless page.uri
    page.uri.to_s
  end

  def location(page)
    return "" unless page.search("li.location")
    page.search("li.location").text
  end

  def id(page, type)
    id_div = page.search("div.company-header-info div")
    return "" unless id_div
    return "" unless id_div.text
    return "" unless id_div.text.match(/#{type} Id : (.*?)\n/)
    page.search("div.company-header-info div").text.match(/#{type} Id : (.*?)\n/)[1]
  end

  def date(page)
    return "" unless page.search("li.posted")
    date_string = page.search("li.posted").text
    string_to_date(date_string)
  end

  def string_to_date(posted_string)
    integer = posted_string.split(" ")[1].to_i
    time_unit = posted_string.split(" ")[2]
    time_unit << "s" if time_unit[-1] != "s"
    seconds_ago = UNITS_TO_SECONDS[time_unit.to_sym]*integer
    posted_date = Time.now - seconds_ago
  end

end

