require 'nokogiri'
require 'mechanize'

agent = Mechanize.new
agent.get("https://www.dice.com")