require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

Job = Struct.new(:title, :descript, :employer, :link, :location, :posted, :dice_id, :job_id)

class Scraper

  def initialize
    @mech = Mechanize.new
    @mech.user_agent_alias = 'Mac Safari'
    @page = nil
    # this gives your Mechanize object
    # an 0.5 second wait time after every HTML request
    # Don't forget it!!!
    @mech.history_added = Proc.new { sleep 0.5 }
    @jobs = []
  end

  def scrape_jobs(date)
    @page = @mech.get('https://www.dice.com/jobs?q=Ruby+on+Rails&l=New+York%2C+NY')
    results = @page.search('#search-results-control .col-md-9 #serp .serp-result-content')

    results.each do |job|
      job_title = job.at('h3 a').attributes["title"].value
      job_shortdesc = job.css('div.shortdesc').text.strip
      employer = job.css('li.employer span.hidden-md a').text.strip
      job_link = job.at('h3 a').attributes["href"].value
      location = job.css('li.location').text.strip
      rel_time_arr = job.css('li.posted').text.split(" ")
      now = Time.now
      time_num = rel_time_arr[0].to_i
      time_string = rel_time_arr[1]

      time_hash = { year: 365*24*60*60, years: 365*24*60*60,
                    week: 7*24*60*60, weeks: 7*24*60*60,
                    month: 30*24*60*60, months: 30*24*60*60,
                    day: 24*60*60, days: 24*60*60,
                    hour: 60*60, hours: 60*60,
                    minute: 60, minutes: 60,
                    second: 1, seconds: 1 }


      actual_time = now - time_num*time_hash[time_string.downcase.to_sym]

      next if actual_time < date

      # obtain mechanized job page by following job_link
      job_page = @mech.get(job_link)

      #scraping job page for each job
      company_info = job_page.search('.company-header-info').first
      ids = company_info.css('div.row div.col-md-12')

      if ids.length == 2
        dice_id = ids[0].text.strip[10..-1]
        job_id = ids[1].text.strip[13..-1]
      elsif ids.length == 3
        dice_id = ids[1].text.strip[10..-1]
        job_id = ids[2].text.strip[13..-1]
      end

      @jobs << [job_title, job_shortdesc, employer, job_link, location, actual_time, dice_id, job_id]

      # p job_title
      # p employer
      # p "#{dice_id} #{job_id}"
      # puts
    end


  end

  def create_csv
    CSV.open("jobs.csv", 'a') do |csv|
      # csv << ["job_title", "job_shortdesc", "employer", "job_link", "location", "actual_time", "dice_id", "job_id"]
      @jobs.each do |job|
        csv << job
      end
    end
  end
end

scraper = Scraper.new

scraper.scrape_jobs(Time.new(2016, 1, 18))
scraper.create_csv

# job title, keywords input field id='search-field-keyword'
# location id='search-field-location'
# button type='submit', text='Find Tech Jobs'

# Search URL
#
# https://www.dice.com/jobs?q=ruby+on+rails&l=
# https://www.dice.com/jobs?q=Ruby+on+Rails

# grab everything under each div class='serp-result-content'
# broken into
# h3 (grab a tag with title attribute)
# div class='shortdesc'
# ul class='list-inline details'
# => li class='employer'
# => li class='location'
# => li class='posted'
# Filters are JavaScript only
