require 'rubygems'
require 'mechanize'

class DiceAgent < Mechanize

  def search(term)
    url = "https://www.dice.com/jobs?q="
    query = term.gsub(" ", "+")
    page = get(url + query)
    page.search(".serp-result-content h3 a")
  end
end

d = DiceAgent.new do |agent| 
    agent.user_agent_alias = 'Windows Chrome'
end

jobs = d.search("rails")


p jobs.length

jobs.each do |job|
  puts job.attr("title")
end