require 'rubygems'
require 'mechanize'

JobPosting = Struct.new(:title, :company, :location, :link, :post_date, :job_id )

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
    page.css("div.row.result")
  end

  # parses a job listing for the job title.
  def parse_job_title(listing)
    listing.css(".jobtitle").text.strip
  end

  # parses a job listing for the hiring company.
  def parse_company_name(listing)
    listing.css(".company").text.strip
  end

  # parses a job listing for the link to the job.
  # the links are all local to the site, so we have
  # to append the site's URL to the front of each link.
  def parse_job_link(listing)
    "#{BASE_URL}#{listing.css(".turnstileLink").css("a").attribute("href").value.strip}"
  end

  # parses a job listing for the location.
  # only interested in jobs in SG for now, so may be superfluous,
  # but could prove useful in future.
  def parse_job_location(listing)
    listing.css(".location").text.strip
  end

  # parses a job listing for the date it was posted.
  # job sites typically just state "X days ago", or "X hours ago",
  # so some processing will be required.
  def parse_job_post_date(listing)
    # we remove any "+" characters from the raw date text
    raw_date = listing.css(".date").text.strip.gsub("+", "")

    # parse the raw date to determine how many days/hours ago the
    # job listing was posted.
    parsed_raw_date = raw_date.match(/(\d+)\s(\w+)\sago/i).captures
    time_value = parsed_raw_date[0]
    time_unit = parsed_raw_date[1]
    job_posted = nil

    if time_unit =~ /day(s)?/
      job_posted = (Time.now - (time_value.to_i * 24 * 60 * 60))
    elsif time_unit =~ /hour(s)?/
      job_posted = (Time.now - (time_value.to_i * 60 * 60))
    end

    "#{job_posted.year}-#{job_posted.month}-#{job_posted.day}"
  end

  # parses the job listing for its id. Not sure what value there is in this..
  def parse_job_id(listing)
    listing.attribute("id").value.strip
  end

  # returns an array of JobPosting structs, to prepare for outputting to a file
  def create_job_postings
    job_postings = []

    # get the first page of search results.
    page = self.agent.get(JobSiteScraper::FIRST_RESULTS_PAGE)
    while page
      # scrape all job listings
      job_listings = scrape_job_listings(page)

      # grab relevant info from job listings
      job_listings.each do |listing|
        job_posting = JobPosting.new
        job_posting.title = parse_job_title(listing)
        job_posting.company = parse_company_name(listing)
        job_posting.location = parse_job_location(listing)
        job_posting.link = parse_job_link(listing)
        job_posting.post_date = parse_job_post_date(listing)
        job_posting.job_id = parse_job_id(listing)

        job_postings << job_posting
      end

      # now find the "Next" link and click on it
      if page.link_with(:text => /Next/)
        page = page.link_with(:text => /Next/).click
      else
        break
      end
    end

    job_postings
  end
end

if $0 == __FILE__
  scraper = JobSiteScraper.new
  pp scraper.create_job_postings
end
