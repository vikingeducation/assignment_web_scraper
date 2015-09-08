require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'
require 'nokogiri'
require 'pry'

class Scraper
  attr_reader :page, :results

  def initialize

    @agent = Mechanize.new

    # add rate limit of 500ms between requests
    @agent.history_added = Proc.new { sleep 0.5 }

  end

  def scrap

    # skip form, go directly to results
    @page = @agent.get("https://www.dice.com/jobs?q=web+developers&l=Roslyn%2C+NY")

    # all results contain necessary information under one class
    @results = @page.search(".//div[@class='serp-result-content']")

    # build final results
    jobs = build_jobs(@results)

    # save to CSV file
    save_results(jobs)

  end

  def build_jobs(search_results)

    jobs = []
    search_results.each do |job|

      job_title = job.at_css('h3 a').text.strip
      company_name = job.at_css('li a').text.strip
      post_link = job.at_css('h3 a').attribute('href').value
      location = job.at_css('li.location').text
      post_date = get_date(job.at_css('li.posted').text)

      # capture every instance of characters in between '/' and '/'.  only returns the last value which is the company ID
      company_ID = job.at_css('h3 a').attribute('href').value.scan(/([^\/]*)\//)[-1][0]

      # capture all values before the first question mark
      job_ID = job.at_css('h3 a').attribute('href').value.match(/([^\/]*)\?/)[1]

      jobs << [job_title, company_name, post_link, location, post_date, company_ID, job_ID]

    end

    jobs

  end

  def get_date(post_time)

    # gives value of time (e.g. "1" minute, "3" hours)
    value = post_time.split(' ')[0].to_i

    # gives type of time (e.g. 2 "weeks", 6 "hours")
    time_type = post_time.split(' ')[1]

    # returns type of time as singular (e.g. weeks --> week) for case structure
    time_type = time_type[0..-2] if time_type[-1] == "s"

    # strictly returns the date (MM/DD/YYYY)
    case time_type.downcase

      # subtract seconds ago
      when "second"
        Time.at(Time.now.to_i-value).strftime("%m-%d-%Y")

      # subtract minutes ago
      when "minute"
        Time.at(Time.now.to_i-value*60).strftime("%m-%d-%Y")

      # subtract hours ago
      when "hour"
        Time.at(Time.now.to_i-value*60*60).strftime("%m-%d-%Y")

      # subtract days ago
      when "day"
        Time.at(Time.now.to_i-value*60*60*24).strftime("%m-%d-%Y")

      # subtract weeks ago
      when "week"
        Time.at(Time.now.to_i-value*60*60*24*7).strftime("%m-%d-%Y")

    end

  end

  # saves results to a CSV file
  def save_results(jobs)

    CSV.open('dice_job_directory.csv', 'a') do |csv|
      jobs.each do |job|
        csv << job
      end
    end

  end

end

test = Scraper.new
test.scrap