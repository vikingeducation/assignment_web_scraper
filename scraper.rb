require 'rubygems'
require 'bundler/setup'
require 'mechanize'

# create a scraper that performs a search query and returns the first results page

scraper = Mechanize.new

page = scraper.get('https://www.dice.com')
pp page
# form = page.form_with(:id => 'search-field-keyword')
# google_form.q = 'javascript'


scraper.history_added = Proc.new { sleep 0.5 }

