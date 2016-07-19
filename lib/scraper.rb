require 'rubygems'
require 'mechanize'

scraper = Mechanize.new

page = scraper.get('https://www.dice.com')
puts page


scraper.history_added = Proc.new { sleep 0.5 }
