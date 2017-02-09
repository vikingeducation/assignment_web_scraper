# dice test

require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'pry'
require 'pry-nav'

# this is all it takes. CSV is standard.
require 'csv'

# binding.pry

agent = Mechanize.new

agent.history_added = Proc.new{sleep 0.5}

page = agent.get('http://dice.com/')

dice_form = page.form_with(id: 'search-form')

# another_form = page.form_with(:id => "some_id")
# another_form = page.form_with(:action => "/some_path")

# dice_form.q = 'ruby mechanize'

page = dice_form.submit

results = page.search(".serp-result-content")

# agent.get('http://someurl.com/').search(".//p[@class='posted']")

# pp results

puts "\n"



results.each do |item|# 
  puts item
  print "press return"
  gets.chomp
end

 


# the 'a' is important
# it turns on Append Mode so you don't overwrite
# your own scrape file
CSV.open('csv_file.csv', 'a') do |csv|
    # each one of these comes out in its own row.
    csv << []
    csv << []
end
