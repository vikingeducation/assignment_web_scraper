
require 'rubygems'
require 'nokogiri'  
require 'open-uri'  # our chosen HTTP library

# Use `open-uri`'s `open` method to grab the page
page = Nokogiri::HTML(open("https://www.dice.com/jobs/advancedResult.html?for_all=junior+developer&for_one=rails+ruby&for_loc=San+Francisco%2C+CA&limit=50&radius=20&postedDate=15&sort=relevance&jtype=Full+Time"))  

# Helpers for searching and returning the element's text
page.css("div").first.text

first_title =  page.css("a#position0").text
puts first_title.inspect
first_title.gsub("\t","")
puts first_title