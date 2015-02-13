require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'csv'

# Struct for holding data

JobPosting = Struct.new(:job_title, :company_name, :link, :location, :posting_date, :company_id, :job_id)

# Scrape https://www.dice.com/jobs?q=ruby&l=
agent = Mechanize.new

page = agent.get('http://www.dice.com')
search_jobs = page.form_with(:class => 'search-form')
search_jobs.q =  'web development'
search_jobs.l = 'montana'

results_page = agent.submit(search_jobs) # Returns first page

# Pull job title, company name, link to posting on dice, location, absolute posting date, company ID, job ID

csv_array = []
position = 0

# Open CSV file

CSV.open('job_postings.csv', 'a') do |csv|
  loop do
    begin
      job_title = results_page.search("a#position#{position}.dice-btn-link").text
      company = results_page.search("a#company#{position}.dice-btn-link").text
      location = results_page.search("li.location")[position].text
      posted_time = results_page.search("li.posted")[position].text

      csv_array << job_title
      csv_array << company
      csv_array << location
      csv_array << posted_time
    rescue
      puts "position is #{position}"
      break
    end
    position += 1
  end
  csv << csv_array
end
