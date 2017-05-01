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

  # scrapes the page for each div that contains a job listing
  def scrape_job_listings(page)
    job_listings = page.css("div.row.result")
  end

  # parses a job listing for the job title
  def scrape_job_titles(listing)
    listing.css(".jobtitle").text
  end

  # parses a job listing for the hiring company
  def scrape_company_name(listing)
    listing.css(".company").text.strip
  end
end

if $0 == __FILE__
  scraper = JobSiteScraper.new
  pp scraper.agent

  # open page we want
  page = scraper.agent.get('https://www.indeed.com.sg/jobs?q=ruby&l=Singapore')

  job_listings = scraper.scrape_job_listings(page)

  # pp scraper.scrape_job_titles(job_listings.first)
  job_listings.each do |listing|
    pp scraper.scrape_job_titles(listing)
    pp scraper.scrape_company_name(listing)
  end
end
