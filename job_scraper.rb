require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

scraper = Mechanize.new do |agent|
  agent.user_agent_alias = 'Windows Chrome'
  # this gives your Mechanize object
  # a 0.7 second wait time after every HTML request
  # Don't forget it!!!
  agent.history_added = Proc.new{sleep 0.7}
end

page = scraper.get('https://www.dice.com/jobs?q=web+developer&l=Eugene%2C+OR&searchid=1383873731361')

results = page.search('div.serp-result-content')

results.each do |job|

  title = job.css('h3 a').first.attributes['title'].text
  company_name = job.css('.hidden-xs .dice-btn-link').text
  link = job.css('li a').first.attributes['href'].text
  location = job.css('.location').first.attributes['title'].text
  posted_date = job.css('li.posted').text
  #company_id = job.css('a.dice-btn-link').first.attributes['value'].text
  job_id = job.css('a.dice-btn-link').first.attributes['value'].text

  CSV.open('jobs_file.csv', 'a') do |csv|
    csv << ["#{title}, #{company_name}, #{link}, #{location}, #{posted_date}, #{job_id}"]
  end

  #puts
  #puts "#{title}"
  #puts "#{company_name}"
  #puts "#{link}"
  #puts "#{location}"
  #puts "#{posted_date}"
  #puts # "#{company_id}"
  #puts "#{job_id}"
  #puts "***********************"
end