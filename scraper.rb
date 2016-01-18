require 'rubygems'
require 'bundler/setup'
require 'mechanize'

Job = Struct.new(:title, :descript, :employer, :location, :posted)

class Scraper

  def initialize
    @mech = Mechanize.new
    # this gives your Mechanize object
    # an 0.5 second wait time after every HTML request
    # Don't forget it!!!
    @mech.history_added = Proc.new { sleep 0.5 }

  end

  def scrape_jobs
    results = @mech.get('https://www.dice.com/jobs?q=Ruby+on+Rails&l=New+York%2C+NY').search('.serp-result-content')

    results.each do |job|
      # current_job = Job.new
      # current_job.title = link.text
      puts job
      puts
    end
    pp search
  end

end

scraper = Scraper.new

scraper.scrape_jobs

# job title, keywords input field id='search-field-keyword'
# location id='search-field-location'
# button type='submit', text='Find Tech Jobs'

# Search URL
#
# https://www.dice.com/jobs?q=ruby+on+rails&l=
# https://www.dice.com/jobs?q=Ruby+on+Rails

# grab everything under each div class='serp-result-content'
# broken into
# h3 (grab a tag with title attribute)
# div class='shortdesc'
# ul class='list-inline details'
# => li class='employer'
# => li class='location'
# => li class='posted'
# Filters are JavaScript only
