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
  end

end


# page.link_with(:href => /foo/).click


class JobParser

  attr_reader :page

  def initialize(job_page)
    @agent = Mechanize.new
    @page = job_page
  end

  def get_url(page_number)
    url = @page.uri.to_s + "&startPage=#{page_number}"
  end

  def get_all_jobs
    current_page = @page
    jobs = []
    page_number = 1
    until current_page.body.include?("404 - The page you're looking for couldn't be found or it may have expired.")

      jobs += current_page.links_with(:href => /jobs\/detail/)
      page_number += 1
      current_page = @agent.get(get_url(page_number))
    end
    jobs[0...jobs.length/2].length
  end

  def job_count
    @page.links_with(:href => /jobs\/detail/)
  end

end



j = JobSearcher.new("Software Engineer", "Boise, ID")
 p = JobParser.new(j.get_jobs_page)
#p j.get_jobs_page.uri.to_s
# p p.get_all_jobs

p p.get_all_jobs
"https://www.dice.com/jobs/detail/Java-Software-Engineer-CyberCoders-Boise-ID-83701/cybercod/RC3-128271325?icid=sr1-1p&q=Software Engineer&l=Boise, ID"

"https://www.dice.com/jobs/detail/Java-Software-Engineer-CyberCoders-Boise-ID-83701/cybercod/RC3-128271325?icid=sr1-1p&q=Software Engineer&l=Boise, ID"
