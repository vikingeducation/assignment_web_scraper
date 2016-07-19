require 'rubygems'
require 'mechanize'

class WebScraper

  def initialize
  end


end

agent = Mechanize.new
agent.history_added = Proc.new { sleep 3.0 }
page = agent.get("https://www.dice.com")
