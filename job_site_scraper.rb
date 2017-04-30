require 'rubygems'
require 'mechanize'

# A simple job site web scraper, using Mechanize and Nokogiri.
# Instead of scraping dice.com as specified in the assignment,
# I'm scraping indeed.com as Dice doesn't have jobs in SG.
class JobSiteScraper
  attr_reader :agent

  def initialize
    @agent = Mechanize.new

    # rate limit Mechanize instance
    self.agent.history_added = Proc.new { sleep 0.5 }
  end
end

if $0 == __FILE__
  job_site_scraper = JobSiteScraper.new
  pp job_site_scraper.agent
end
