require 'rubygems'
require 'bundler/setup'
require  'mechanize'

# JobListing = Struct.new(:title, )

# class JobSearcher

# end

  agent = Mechanize.new
  page = agent.get("http://www.dice.com/")

  form = page.form_with(:class => "search-form")
  form.q = "software engineer"
  form.l = 'San Francisco, CA'

  job_page = agent.submit(form)
  pp job_page
