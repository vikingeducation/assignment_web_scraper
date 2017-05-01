require 'rubygems'
require 'mechanize'

# A simple job site web scraper, using Mechanize and Nokogiri.
# Instead of scraping dice.com as specified in the assignment,
# I'm scraping indeed.com as Dice doesn't have jobs in SG.
class JobSiteScraper
  attr_reader :agent

  def initialize
    @agent = Mechanize.new do |agent|
      agent.user_agent_alias = 'Windows Chrome'
    end

    # rate limit Mechanize instance
    self.agent.history_added = Proc.new { sleep 0.5 }
  end

  def scrape_job_titles(page)
    job_titles =  page.css("h2.jobtitle a")
    job_titles.each do |job_title|
      pp job_title.children.first.text
    end
  end
end

if $0 == __FILE__
  job_site_scraper = JobSiteScraper.new
  pp job_site_scraper.agent

  # open page we want
  page = job_site_scraper.agent.get('https://www.indeed.com.sg/jobs?q=ruby&l=Singapore')

  job_site_scraper.scrape_job_titles(page)
end
