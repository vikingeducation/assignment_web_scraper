require 'rubygems'
require 'bundler/setup'
require 'mechanize'

JobListing = Struct.new(:title, :company, :link, :location, :date, :dice_id, :position_id)

class JobSearcher

  CONVERSION = {
    
  }

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
    # listings_array = []
    # get_all_links.each do |link|
    #   current_page = link.click
    #   title = current_page.search("h1.jobTitle").text
        # company = current_page.search("li.employer a").text
        #link = current_page.uri.to_s
        #location = current_page.search("li.location").text
        #dice_id = current_page.search("div.company-header-info div").text.match(/Dice Id : (.*?)\n/)[1]
        #company_id = current_page.search("div.company-header-info div").text.match(/Position Id : (.*?)\n/)[1]
        #posted = current_page.search("li.posted").text
    # end
    links = get_all_links
    links[0].click.search("li.posted").text
    

  end

  def datestamp(posted_string)
    posted_array = posted.split(" ")
  end

end

j = JobSearcher.new("Software Engineer", "Boise, ID")
#p j.get_jobs_page.uri.to_s
# p p.get_all_jobs

p j.create_listings
