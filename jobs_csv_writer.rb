require 'csv'
require_relative './job_site_scraper.rb'

class JobsCSVWriter
  attr_reader :job_postings

  def initialize(job_postings)
    @job_postings = job_postings
  end

  def write_jobs_to_csv(filename = nil)
    filename = './temp.csv' if filename.nil?

    CSV.open(filename, 'a') do |csv|
      # :title, :company, :location, :link, :post_date, :job_id

      # write CSV headers
      csv << ["title", "company", "location", "link", "post_date", "job_id"]

      # write each job posting to the CSV file
      self.job_postings.each do |posting|
        csv << [posting.title, posting.company, posting.location, posting.link,
                posting.post_date, posting.job_id]
      end
    end
  end
end

if $0 == __FILE__
  scraper = JobSiteScraper.new
  job_postings = scraper.scrape_job_postings

  jobs_csv_writer = JobsCSVWriter.new(job_postings)
  jobs_csv_writer.write_jobs_to_csv
end
