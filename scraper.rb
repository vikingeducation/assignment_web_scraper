require 'nokogiri'
require 'pp'
require 'mechanize'
require 'byebug'
require 'chronic'
require_relative 'lib/job'

id_regex = /\/([^\/]+)\/([^\/]+?)\?icid/

address = "https://www.dice.com/jobs?q=rails&l=Oakland%2C+NJ"
agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }
page = agent.get(address)
jobs = page.css(".col-md-9 > #serp > .serp-result-content")

jobs_array = []
jobs.each do |job|
  title = job.at("h3 a").attributes["title"].value # job title
  company = job.at(".employer .hidden-md a").text # company name
  link = job.at("h3 a").attributes["href"].value # link to posting on dice
  location = job.at(".location").text # location
  date = Chronic.parse(job.at(".posted").text) # date of posting
  matches = link.match(id_regex)
  if matches
    company_id, job_id = matches.captures
  else
    puts link
  end
  jobs_array << Job.new(title: title, company: company, link: link, location: location, date: date, company_id: company_id, job_id: job_id)
end

pp jobs_array
