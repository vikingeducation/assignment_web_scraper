require 'mechanize'
require 'nokogiri'

# class Scraper





  


# end

s = Mechanize.new
page = s.get("http://www.dice.com")
job_search = page.form_with(:id => "search-form")
job_search.q = "ruby"
job_search.l = "Boston"
page = s.submit(job_search)
jobs = page.field_with(:id => "serp")