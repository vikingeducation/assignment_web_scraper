require 'rubygems'
require 'bundler/setup'
require 'mechanize'

# create a scraper that performs a search query and returns the first results page

scraper = Mechanize.new

page = scraper.get('https://www.dice.com')
form = page.form_with(:id => 'search-form')
form.q = 'javascript'
form.l = 'philadelphia' 
page = scraper.submit(form)

array = page.links.select do |link|
  link.text =~ /Developer/
end

p array

scraper.history_added = Proc.new { sleep 0.5 }

