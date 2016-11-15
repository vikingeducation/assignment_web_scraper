require 'rubygems'
require 'mechanize'
require 'bundler/setup'
require_relative 'job'


class Scraper
  SEO = /<title>(\w.*?)\|/

  def initialize
  end

  agent = Mechanize.new
  agent.history_added = Proc.new { sleep 0.5 }

  page = agent.get('https://www.dice.com/jobs/q-web_development-jtype-Full+Time-sort-date-limit-30-l-San_Francisco%2C_CA-radius-10-jobs.html?searchid=6756117910756')


  page.links_with(:href => /www.dice.com\/jobs\/detail\//).each do |page_link|
    pp page_link.href

    current_job = Job.new(page_link)
    job_listing = link.click

    seo_tags = job_listing.scan(SEO)
    seo_tags = seo_tags.split(" - ")
    # [Job Title, Company, City and State, Date]


  end
end
