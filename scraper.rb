require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'nokogiri'
require 'pp'


address = "https://www.dice.com/jobs?q=ruby&l=San+Jose%2C+CA"
agent = Mechanize.new
page = agent.get(address)
jobs = page.search(".col-md-9 > #serp > .serp-result-content")

jobs.each do |job|
  title = job.at("h3 a").attributes["title"].value # job title
  location = job.at(".location").text # location
  print title, location
  puts
end
