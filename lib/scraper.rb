require 'rubygems'
require 'mechanize'

scraper = Mechanize.new


# page = scraper.get('https://www.dice.com')

# p page.links[0].

#job results
page = scraper.get('https://www.dice.com/jobs?q=web+developer&l=San+Jose\%2C+CA')

results = page.css('div.serp-result-content')
str = ""
results.map do |outter_div|
  str += outter_div.css('h3').css('a').text.strip
  str += "\n"
  str += outter_div.css('div.shortdesc').text.strip
  str += "\n"
  details = outter_div.css('ul')
  str += details.css('li.employer').css('span.hidden-md hidden-sm hidden-lg visible-xs').css('a').text.strip
  str += "\n"
  str += details.css('li.location').text.strip
  # str += "\n"
  # str += details.css('li.posted').css('span.icon-calendar-2').text.strip
  str += "\n"
end

puts str

# h3 includes a link that has the job title
# div class "shortdesc" contains a short description
# ul class "list-inline details" contains li's "employer", "location", "posted"



scraper.history_added = Proc.new { sleep 0.5 }
