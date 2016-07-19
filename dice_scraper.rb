require 'rubygems'
require 'bundler/setup'
require 'mechanize'

JobListing = Struct.new(:title, :company, :link, :location, :date, :company_id, :job_id)

class JobSearcher

  def initialize(position, location)
    @position = position
    @location = location
    @agent = Mechanize.new
    @home_page = @agent.get("http://www.dice.com/")
  end

  def get_jobs_page
    form = @home_page.form_with(:class => "search-form")
    form.q = @position
    form.l = @location
    job_page = @agent.submit(form)
    # pp job_page
  end

end


# page.link_with(:href => /foo/).click


class JobParser

  attr_reader :page

  def initialize(job_page)
    @page = job_page
  end

  def get_all_jobs
    current_page = @page
    jobs = []
    loop do
      jobs + current_page.links_with(:href => /jobs\/detail/)
      current_page.link_with(:title => "Go to next page" ).click
    end
    jobs
  end

  def job_count
    @page.links_with(:href => /jobs\/detail/)
  end

end


j = JobSearcher.new("Software Engineer", "San Francisco, CA")
p = JobParser.new(j.get_jobs_page)

p p.get_all_jobs

