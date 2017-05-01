require 'rubygems'
require 'mechanize'

# A simple job site web scraper, using Mechanize and Nokogiri.
# Instead of scraping dice.com as specified in the assignment,
# I'm scraping indeed.com as Dice doesn't have jobs in SG.
class JobSiteScraper
  BASE_URL = 'https://www.indeed.com.sg'
  FIRST_RESULTS_PAGE = "#{BASE_URL}/jobs?q=ruby&l=Singapore"

  attr_reader :agent

  def initialize
    @agent = Mechanize.new do |agent|
      agent.user_agent_alias = 'Windows Chrome'
    end

    # rate limit Mechanize instance.
    self.agent.history_added = Proc.new { sleep 0.5 }
  end

  # scrapes the page for each div that contains a job listing.
  def scrape_job_listings(page)
    job_listings = page.css("div.row.result")
  end

  # parses a job listing for the job title.
  def scrape_job_title(listing)
    listing.css(".jobtitle").text.strip
  end

  # parses a job listing for the hiring company.
  def scrape_company_name(listing)
    listing.css(".company").text.strip
  end

  # parses a job listing for the link to the job.
  # the links are all local to the site, so we have
  # to append the site's URL to the front of each link.
  def scrape_job_link(listing)
    "#{BASE_URL}#{listing.css(".turnstileLink").css("a").attribute("href").value.strip}"
  end

  # parses a job listing for the location.
  # only interested in jobs in SG for now, so may be superfluous,
  # but could prove useful in future.
  def scrape_job_location(listing)
    listing.css(".location").text.strip
  end

  # parses a job listing for the date it was posted.
  # job sites typically just state "X days ago", or "X hours ago",
  # so some processing will be required.
  def scrape_job_posting_date(listing)
    # we remove any "+" characters from the raw date text
    raw_date = listing.css(".date").text.strip.gsub("+", "")

    # parse the raw date to determine how many days/hours ago the
    # job listing was posted.
    parsed_raw_date = raw_date.match(/(\d+)\s(\w+)\sago/i).captures
    time_value = parsed_raw_date[0]
    time_unit = parsed_raw_date[1]
    job_posted = nil

    if time_unit == "days"
      job_posted = (Time.now - (time_value.to_i * 24 * 60 * 60))
    elsif time_unit == "hours"
      job_posted = (Time.now - (time_value.to_i * 60 * 60))
    end

    "#{job_posted.year}-#{job_posted.month}-#{job_posted.day}"
  end

  # parses the job listing for its id. Not sure what value there is in this..
  def scrape_job_id(listing)
    listing.attribute("id").value.strip
  end
end

if $0 == __FILE__
  scraper = JobSiteScraper.new
  pp scraper.agent

  # open page we want.
  page = scraper.agent.get(JobSiteScraper:: FIRST_RESULTS_PAGE)

  job_listings = scraper.scrape_job_listings(page)

  job_listings.each do |listing|
    pp scraper.scrape_job_title(listing)
    pp scraper.scrape_company_name(listing)
    pp scraper.scrape_job_link(listing)
    pp scraper.scrape_job_location(listing)
    pp scraper.scrape_job_posting_date(listing)
    pp scraper.scrape_job_id(listing)
    puts
  end
end
