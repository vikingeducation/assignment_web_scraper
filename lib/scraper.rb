require 'rubygems'
require 'mechanize'
require 'bundler/setup'
require_relative 'job'


class Scraper

  def initialize
    
  end

# page.css("div").first.text
# page.css("div#gbar .gb1").each { |el| puts el.text }



end




agent = Mechanize.new
agent.history_added = Proc.new { sleep 0.5 }

page = agent.get('https://www.dice.com/jobs/q-web_development-jtype-Full+Time-sort-date-limit-30-l-San_Francisco%2C_CA-radius-10-jobs.html?searchid=6756117910756')
# pp page


page.links_with(:href => /www.dice.com\/jobs\/detail\//).each do |link|
  pp link

  # @current_job = Job.new
  job_listing = link.click

  end


