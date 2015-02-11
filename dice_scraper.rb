require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'mechanize'
require_relative 'job'

class DiceScraper

  attr_accessor :agent
  attr_reader :page, :results, :search_form

  def initialize
    @agent = Mechanize.new
    @page = agent.get('http://www.dice.com')
    @search_form = page.form_with(:action=> "/jobs")
    set_query "Ruby on Rails"
    set_location "94612"
    @results = agent.submit(search_form)
  end

  def set_query(query)
    @search_form.q = query
  end

  def set_location(location)
    @search_form.l = location
  end

  def create_job_from_link(num)
    link = results.link_with id: "position#{num}"
    href = link.href
    job_page = agent.get(href)

    name = job_page.search(".jobTitle").first.text
    company = job_page.search(".employer").first.text.strip
    location = job_page.search(".location").first.text
    # month = header_info[-3].strip.to_i
    # day = header_info[-2].strip.to_i
    # year = header_info[-1][0..3].to_i
    # posting_date = Date.new(year,month,day)
    company_id = /.*\/(.*?)\/.*$/.match(href)[1]
    job_id = /.*\/(.*?)$/.match(href)[1]
    # Job.new(name,company,href,location,posting_date,company_id,job_id)
  end
end