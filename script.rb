require 'rubygems'
require 'bundler/setup'
require 'mechanize'

class DiceScraper 
  attr_reader :agent
  def initialize 
    @agent = Mechanize.new
  end
end

d = DiceScraper.new

page = d.agent.get('http://www.dice.com/')


pp page
