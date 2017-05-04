require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv' 


# the 'a' is important
# it turns on Append Mode so you don't overwrite
# your own scrape file
CSV.open('csv_file.csv', 'a') do |csv|
    # each one of these comes out in its own row.
    # csv << ['Harry', 'Potter', 'Wizard', '7/31/1980', 'Male', 'England']
    # csv << ['Bugs', 'Bunny', 'Cartoon', '7/27/1940', 'Male', 'The Woods']
end


# Web Scraper to search job postings

Job = Struct.new(:title, :company, :location, :link, :post_date, :job_id )

# Instantiate a new Mechanize
scraper = Mechanize.new

# this gives your Mechanize object
# an 0.5 second wait time after every HTML request
# Don't forget it!!!
scraper.history_added = Proc.new { sleep 0.5 }

# maximum "depth" you're willing to go

# Grab and parse our page in one step
page = scraper.get('http://uk.dice.com/')


dice_form = page.form

# Enter the search terms abd submit the form
dice_form.SearchTerms = "Ruby"
dice_form.LocationSearchTerms = "London"
dice_form.Radius = 10
dice_form.checkbox_with(:name => 'JobTypeFilter_2').check

button = dice_form.button_with(:value => "Search")

# Actually submit the form
# page = scraper.submit(dice_form, dice_form.buttons.first)
page = scraper.submit(dice_form, button)

job_links = []

# page.links_with(:href => /IT-Job/).each do |link|
#   job_links << link
#   puts "This is a job link #{link}"
#   link.click
# end

page.links_with(:href => /IT-Job/)[20].click
  


# page.each do |job|
#   job_post = Job.new
#   job_post.title = 

# Print out the page using the "pretty print" command
pp page