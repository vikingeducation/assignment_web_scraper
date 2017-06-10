# /scraper.rb
require 'rubygems'
require 'mechanize'

agent = Mechanize.new

agent.history_added = Proc.new {sleep 0.5}

job_site = "http://www.dice.com"
results = []

# Submit the search criteria
agent.get(job_site) #{ |page|
page = agent.get(job_site)
form = page.form_with(:action => "/jobs")
form.q = 'Ruby'
form.l = 'Washington, DC'
pp page
# page2 = agent.submit(form, form.button_with(:type => "submit"))
page2 = agent.submit(form, form.buttons.first)
pp page2



# Scrape the results page(s)

# Add the results as struts?

# append results.csv document
