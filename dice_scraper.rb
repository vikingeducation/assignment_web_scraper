require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

class DiceScraper

  def initialize
    @mech = Mechanize.new
    @mech.user_agent_alias = 'Mac Safari'
    @mech.history_added = Proc.new { sleep 0.5 }
    @page = nil
    @jobs = []
  end

  def scrape_jobs(date)
    (1..10).each do |page_num|
      print "Currently scraping page #{page_num}"

      @page = @mech.get("https://www.dice.com/jobs/q-Ruby_on_Rails-limit-30-l-New_York%2C_NY-radius-30-startPage-#{page_num}-limit-30-jobs")
      results = @page.search('#search-results-control .col-md-9 #serp .serp-result-content')

      scrape_page(results, date)
    end
    puts "Scraping Complete!"
  end

  def scrape_page(nokogiri_result, date)
    nokogiri_result.each do |job|
      print "."

      next if get_date(job) < date

      ids = get_ids(job)
      @jobs << [get_job(job), get_descript(job), get_employer(job), get_link(job), get_location(job), get_date(job), ids[0], ids[1]]
    end
    puts
  end

  def get_job(job)
    job.at('h3 a').attributes["title"].value
  end

  def get_descript(job)
    job.css('div.shortdesc').text.strip
  end

  def get_employer(job)
    job.css('li.employer span.hidden-md a').text.strip
  end

  def get_link(job)
    job.at('h3 a').attributes["href"].value
  end

  def get_location(job)
    job.css('li.location').text.strip
  end

  def get_date(job)
    time_hash = { year: 365*24*60*60, years: 365*24*60*60,
                  week: 7*24*60*60, weeks: 7*24*60*60,
                  month: 30*24*60*60, months: 30*24*60*60,
                  day: 24*60*60, days: 24*60*60,
                  hour: 60*60, hours: 60*60,
                  minute: 60, minutes: 60,
                  second: 1, seconds: 1 }

    rel_time_arr = job.css('li.posted').text.split(" ")
    now = Time.now
    time_num = rel_time_arr[0].to_i
    time_string = rel_time_arr[1]

    return now - time_num*time_hash[time_string.downcase.to_sym]
  end

  def get_ids(job)
    # obtain mechanized job page by following job_link
    job_page = @mech.get(get_link(job))

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

    return [dice_id, job_id]
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

scraper = DiceScraper.new

scraper.scrape_jobs(Time.new(2016, 1, 18))
scraper.create_csv
# https://www.dice.com/jobs/q-Ruby_on_Rails-limit-30-l-New_York%2C_NY-radius-30-startPage-1-limit-30-jobs
# https://www.dice.com/jobs/q-Ruby_on_Rails-limit-30-l-New_York%2C_NY-radius-30-startPage-2-limit-30-jobs

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
