require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'nokogiri'
require 'pp'
require 'csv' 

address = "https://www.dice.com/jobs?q=ruby&l=San+Jose%2C+CA"
agent = Mechanize.new
page = agent.get(address)
jobs = page.search(".col-md-9 > #serp > .serp-result-content")

CSV.open('dice_job.csv', 'a') do |csv|
  
  jobs.each do |job|
    title = job.at("h3 a").attributes["title"].value # job title
    location = job.at(".location").text # location
    company = job.at("ul li span a").text # location
    print title, location, company
    puts

    csv << [title, location]
  
  end
end






# you don't need a CSV.close, 
# because it's wrapped in a block

# Job title
# Company name
# Link to posting on Dice
# Location
# Posting date (not a relative date like "x weeks ago" because that will quickly be meaningless)
# Company ID
# Job ID