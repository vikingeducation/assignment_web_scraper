require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'time'

JobListing = Struct.new(:title, :company, :link, :location, :date, :dice_id, :position_id)

  UNITS_TO_SECONDS = { minutes: 60,
                        hours: 3600,
                        days: 3600*24,
                        weeks: 3600*24*7,
                        months: 3600*24*30,
                        years: 3600*24*365 }

class DiceScraper

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

  def get_other_pages(page_number)
    url = @job_page.uri.to_s + "&startPage=#{page_number}"
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

  def create_listings
    listings_array = []
    get_all_links.each do |link|
      current_page = link.click
      title = current_page.search("h1.jobTitle").text
      company = current_page.search("li.employer a").text
      link = current_page.uri.to_s
      location = current_page.search("li.location").text
      dice_id = current_page.search("div.company-header-info div").text.match(/Dice Id : (.*?)\n/)[1]
      position_id = current_page.search("div.company-header-info div").text.match(/Position Id : (.*?)\n/)[1]
      date_string = current_page.search("li.posted").text
      date = datestamp(date_string)
      listings_array << [title, company, link, location, date, dice_id, position_id]
    end
    listings_array
  end

  def datestamp(posted_string)
    integer = posted_string.split(" ")[1].to_i
    time_unit = posted_string.split(" ")[2]
    time_unit << "s" if time_unit[-1] != "s"
    seconds_ago = UNITS_TO_SECONDS[time_unit.to_sym]*integer
    posted_date = Time.now - seconds_ago
  end
end

j = DiceScraper.new("Software Engineer", "Fresno, CA")
#p j.get_jobs_page.uri.to_s
# p p.get_all_jobs

p (j.create_listings)
