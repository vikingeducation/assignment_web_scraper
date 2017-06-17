# /scraper.rb
require 'rubygems'
require 'mechanize'
require 'csv'

# Job Struct
Job = Struct.new(:title, :comp, :link, :loc, :date, :comp_id, :job_id)

# Create scraper
class JobScraper
  def initialize
    @agent = Mechanize.new
    @agent.history_added = Proc.new {sleep 0.5}
    @job_site = "http://www.dice.com"
    @output = []
  end

# scrape the website
  def scrape
    @agent.get(@job_site)
    page = @agent.get(@job_site)
    form = page.form_with(:action => "/jobs")
    form.q = 'Ruby'
    form.l = 'Washington, DC'
    job_links = @agent.submit(form, form.buttons.first)
    job_links.links_with(:href => %r{/jobs/detail/}).each do |link|
      current_job = Job.new
      current_job.link = link.href
      id_matches = link.href.match(%r{\d{5}\/(.+)\/(.+)\?})
      current_job.comp_id, current_job.job_id = id_matches.captures if id_matches
      job_page = link.click
      capt_group = job_page.at('title').text.match(%r{(.+) - (.+) - (.+) - (\d{2}-\d{2}-\d{4})})
      if capt_group
        current_job.title = capt_group[1]
        current_job.comp = capt_group[2]
        current_job.loc = capt_group[3]
        current_job.date = capt_group[4]
        @output << current_job
      else
        puts "Failure at #{job_page.at('title').text}"
        fail_count += 1
      end
    end
    write_to_file
  end


private

# write to .csv file
  def write_to_file
    CSV.open("results.csv", "a") do |csv|
      csv << ["Title", "Company", "Link", "Location", "Date", "Company ID", "Job ID"]
      @output.each do |job|
        csv << [job.title, job.comp, job.link, job.loc, job.date, job.comp_id, job.job_id]
      end
    end
  end
end

boom = JobScraper.new.scrape
