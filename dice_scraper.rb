require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'mechanize'
require 'csv'
require_relative 'job'

class DiceScraper

  attr_accessor :agent
  attr_reader :page, :job_elements, :search_form

  def initialize
    @agent = Mechanize.new
    @page = agent.get('http://www.dice.com')
    @search_form = page.form_with(:action=> "/jobs")
    set_query "Ruby on Rails"
    set_location "94612"
    results = agent.submit(search_form)
    @job_elements = results.search("div[@class='serp-result-content']")
    create_jobs
  end

  def set_query(query)
    @search_form.q = query
  end

  def set_location(location)
    @search_form.l = location
  end

  def create_jobs
    i = 0
    @job_elements.each do |element|
      job = create_job_from_link element
      puts i
      puts job
      i += 1
    end
  end

  def create_job_from_link(job_element)
    name = job_element.search("a[@class='dice-btn-link']").text
    company = job_element.search(".employer").text.strip
    link = job_element.search("h3/a").attribute("href").value
    location = job_element.search(".location").first.text
    relative_post_date = job_element.search(".posted").text
    post_date = specify_post_date(relative_post_date)
    company_id = link.split("/")[-2]
    job_id = link.split("/")[-1]
    Job.new(name,company,link,location,post_date,company_id,job_id)
  end

  def specify_post_date(relative)
    days_ago = days_ago_calculator(relative)
    Date.today - days_ago
  end

  def days_ago_calculator(relative)
    return 0 if relative =~ /hour/
    /^(\d+)\s/.match(relative)[1].to_i if relative =~ /day/
  end
end