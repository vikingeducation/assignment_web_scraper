require 'rubygems'
require 'bundler/setup'
require 'mechanize'

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

# page.links.each do |link|
#   puts link.text
# end

#  # If you wanted to click on the first news link, you could do this
# page = scraper.page.link_with(:text => 'News')[1].click


# # Grab the form of class="f" from the page
dice_form = page.form('f')

# # Grab the form by ID or action
# another_form = page.form_with(:id => "some-id")
# another_form = page.form_with(:action => "/some_path")

# Fill in the field named "q" (Google's search query)
# dice_form.q = 'ruby mechanize'

# Actually submit the form
# page = scraper.submit(dice_form, dice_form.buttons.first)



# Print out the page using the "pretty print" command
pp page