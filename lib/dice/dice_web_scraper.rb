require 'rubygems'
require 'bundler/setup'
require 'mechanize'

class DiceWebScraper
  def initialize 
    @agent = Mechanize.new
  end

  # assume search_query is a string: 'hi i am a string', zip is #####
  # radius is a number... 5, 10, 20, 30 (default), 40, 50 ,75, 100
  # num_results is the number of jobs found to save to file (default: 30, one page)
  def search_jobs(search_query, zip, radius = 30, num_results = 30) 
    url = generate_url(search_query, zip, radius)
    page = @agent.get(url)
    jobs = page.search('div.complete-serp-result-div')
    all_jobs = []
    jobs.each do |job|
      p job_title = job.search('li h3').text.strip
      p company = job.search('li.employer span.hidden-xs').text
      p job_link = job.search('li h3 a')[0].attributes['href'].value
      p location = job.search('li.location').text
      p posted_relative = job.search('li.posted').text
      # post_date
      company_id_link = job.search('div.logopath a')[0].attributes['href'].value
      p company_id = extract_cid_from_link(company_id_link)
      p job_id = extract_jid_from_link(company_id, job_link)
      #jobs << [job_title, company, job_link, location, posted_relative, company_id, job_id]
    end
    #jobs 
  end

  private

  def extract_cid_from_link(company_id_link)
    company_id_link.sub('https://www.dice.com/company/','')
  end 

  def extract_jid_from_link(company_id, job_link)
    job_link.match(/.*?#{company_id}\/(.*?)[?]/).captures[0]
  end

  def generate_url(search_query, zip, radius)
    url = 'https://www.dice.com/jobs'
    # default radius is 30 miles
    if radius == 30
      url += "?q=#{search_query.gsub(' ', '+')}"
      url += "&l=#{zip.to_s}"
    else
      url += "/q-#{search_query.gsub(' ', '_')}-limit-30-"
      url += "l-#{zip.to_s}-"
      url += "radius-#{radius.to_s}-jobs.html"
    end
    url
  end
end

scraper = DiceWebScraper.new
p scraper.search_jobs('ruby rails', 10001)
