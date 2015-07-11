# require "rubygems"
# require "nokogiri"
# require "open-uri"
require "mechanize"

agent = Mechanize.new

page = agent.get('http://www.dice.com/')