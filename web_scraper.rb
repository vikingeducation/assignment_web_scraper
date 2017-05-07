# Web Scraper to search job postings
require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv' 

Job = Struct.new(:title, :company, :location, :link, :post_date, :job_id )

# Instantiate a new Mechanize
scraper = Mechanize.new

# Grab and parse our page in one step
page = scraper.get('http://uk.dice.com/')
results = []

dice_form = page.form
# Enter the search terms and submit the form
dice_form.SearchTerms = "Ruby"
dice_form.LocationSearchTerms = "London"
dice_form.Radius = 10
dice_form.checkbox_with(:name => 'JobTypeFilter_2').check
button = dice_form.button_with(:value => "Search")

# this gives your Mechanize object
# an 0.5 second wait time after every HTML request
# Don't forget it!!!
scraper.history_added = Proc.new { sleep 0.5 }

# Actually submit the form
page = scraper.submit(dice_form, button)

links = page.parser.css("h2.standardLink").children
# this is the url
# page = page.parser.css("h2.standardLink").children[0].attributes['id'].value

# page = page.parser.css("h2.standardLink").children[0].attributes['href'].value

page = page.parser.css("div#SearchResults").text.strip
page = page.split("\"MESSAGE.ADVERT_SHORTLIST_COUNT_ALERT\" NOT FOUND\n\n\n\n\n\n\n\n\n\n\n")

i = 0
page.each do |job|
  listing = Job.new
  listing.title = job.scan(/\A(.*)\n\nSalary/).join.strip
  listing.company = job.scan(/Advertiser\n\n(.*)/).join.strip
  listing.location = job.scan(/Location:\n(.*)/).join.strip
  listing.link = links[i].attributes['href'].value
  listing.post_date = job.scan(/Last Updated Date\n\n(.*)/).join.strip
  job_link = links[i].attributes['id'].value
  listing.job_id = job_link.scan(/TITLE\[([0-9]+)\]/).join.strip
  results << listing
  i += 1
end

# Test code
# page = page.at("div.searchResultTitle").text.strip


# page.links_with(:href => /http:\/\/uk.dice.com\/IT-Job/).each do |link|
#   job_links << link
#   puts "This is a job link #{link}"
# end

# come back to this as this splits the result in a cleaner way
# result = page.parser.css("div.searchResultTitle").text.strip.split("\n\n\n\n\n\n\n\n") 


# page = page.parser.css("div.searchResultTitle").text.strip
# page.css_at
# page.at


# it turns on Append Mode so you don't overwrite
# your own scrape file
j = 0
CSV.open('csv_file.csv', 'a') do |csv|
  results.each do | item|
    csv << item
  end
end



# Print out the page using the "pretty print" command
pp results
