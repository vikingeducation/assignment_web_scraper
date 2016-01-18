require 'nokogiri'
require 'mechanize'
require 'byebug'
require 'chronic'

id_regex = /\/([a-zA-Z0-9-]+)\/([a-zA-Z0-9-]+)\?icid/

address = "https://www.dice.com/jobs?q=rails&l=Oakland%2C+NJ"
agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }
page = agent.get(address)
jobs = page.css(".col-md-9 > #serp > .serp-result-content")

jobs.each do |job|
  puts job.at("h3 a").attributes["title"].value # job title
  p job.at(".employer .hidden-md a").text # company name
  p link = job.at("h3 a").attributes["href"].value # link to posting on dice
  p job.at(".location").text
  date = Chronic.parse(job.at(".posted").text) # date of posting
  p date
  company_id, job_id = link.match(id_regex)
  p company_id
  p job_id
end
