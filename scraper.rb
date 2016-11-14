require 'rubygems'
require 'bundler/setup'
require 'mechanize'

# scraper = Mechanize.new
# scraper.history_added = Proc.new { sleep 1.0 }

# https://www.dice.com/jobs?q=job&l=Philadelphia%2C+PA&searchid=1651350807861

# https://www.dice.com/jobs/q-ruby-limit-99-startPage-2-limit-99-jobs?searchid=9637969994242

class Dice < Mechanize
  def initialize
    agent = Mechanize.new
    agent.get("https://www.dice.com/jobs?q=&l=")
  end
end

Dice.new