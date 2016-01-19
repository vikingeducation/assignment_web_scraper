require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'nokogiri'
require 'pp'
require 'csv' 

class DiceScraper

  def initialize( address = "https://www.dice.com/jobs?q=ruby&l=San+Jose" )
    @address = address
  end

# address = "https://www.dice.com/jobs?q=ruby&l=San+Jose%2C+CA"




  def scrape
    agent = Mechanize.new
    page = agent.get(@address)

    jobs = page.search(".col-md-9 > #serp > .serp-result-content")
    CSV.open('dice_job.csv', 'w') do |csv|
      
      jobs.each do |job|
        title = job.at("h3 a").attributes["title"].value # job title
        location = job.at(".location").text # location
        company = job.at("ul li span a").text # location
        link = job.at("h3 a").attributes["href"].value
        posted =  job.at(".posted").text
        # # print title, location, company
        # puts
        csv << [ title, location, company, link, posted ]
      end
    end
  
  end
end

scraper = DiceScraper.new
scraper.scrape



# Job title
# Company name
# Link to posting on Dice
# Location
# Posting date (not a relative date like "x weeks ago" because that will quickly be meaningless)
# Company ID
# Job ID