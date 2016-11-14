require 'rubygems'
require 'mechanize'

class DiceAgent < Mechanize

  def search(term)
    url = "https://www.dice.com/jobs?q="
    query = term.gsub(" ", "+")
    page = self.get(url + query)
    page.search("container")
  end
end

d = DiceAgent.new do |agent| 
    agent.user_agent_alias = 'Windows Chrome'
end

page = d.search("rails")

puts page.class