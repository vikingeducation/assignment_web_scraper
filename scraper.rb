
require 'rubygems'
require 'nokogiri'  
require 'open-uri'  # our chosen HTTP library
require 'csv' 





# Use `open-uri`'s `open` method to grab the page
page = Nokogiri::HTML(open("https://www.dice.com/jobs/advancedResult.html?for_all=junior+developer&for_one=rails+ruby&for_loc=San+Francisco%2C+CA&limit=50&radius=20&postedDate=15&sort=relevance&jtype=Full+Time"))  

# Helpers for searching and returning the element's text


links = []
links = page.css('a#position0 a').map { |link| link['href'] }
p links



titles = []
companies = []

# 20.times do |i|
# temp_title = ""
# temp_company = ""

# temp_title =  page.css("a#position#{i}").text
# temp_title.gsub!(/[\t\r\n]/, "")
# temp_title = temp_title[0..temp_title.length/2 - 1]

# temp_company = page.css("a#company#{i}").text
# temp_company.gsub!(/[\t\r\n]/, "")
# temp_company = temp_company[0..temp_company.length/2 - 1]

# titles << temp_title
# companies << temp_company

# end



puts titles
puts "-------"
puts companies
puts "^^^^^^^^^"



# CSV.open('csv_file.csv', 'a') do |csv|
#     # each one of these comes out in its own row.
#     csv << titles
#     csv << companies
# end

# p csv