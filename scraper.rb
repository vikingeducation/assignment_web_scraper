require 'nokogiri'
require 'mechanize'
require 'byebug'

address = "https://www.dice.com/jobs?q=rails"
agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }
page = agent.get(address)
jobs = page.css(".col-md-9 > #serp > .serp-result-content")

jobs.each do |job|
  puts job.at("h3 a").attributes["title"].value
end

