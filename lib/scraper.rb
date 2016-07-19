require 'rubygems'
require 'mechanize'

scraper = Mechanize.new


# page = scraper.get('https://www.dice.com')

# p page.links[0].

#job results
p page = scraper.get('https://www.dice.com/jobs?q=web+developer&l=San+Jose\%2C+CA')

# results = page.css('div#serp-result-content')

# results.each do |result|
#   p result
# end




scraper.history_added = Proc.new { sleep 0.5 }
