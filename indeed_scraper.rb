require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

class IndeedScraper

  def initialize
    @mech = Mechanize.new
    @mech.user_agent_alias = 'Mac Safari'
    @mech.history_added = Proc.new { sleep 0.5 }
    @page = nil
    @jobs = []
  end

  def scrape_jobs(date)
    @page = @mech.get("http://www.indeed.com/jobs?q=Ruby+on+Rails&l=New+York%2C+NY")
    results = @page.search('.result')

    results.each do |result|
      p result
      puts
    end
  end
end

scraper = IndeedScraper.new
scraper.scrape_jobs(Time.new(2016, 1, 18))
#scraper.create_csv
