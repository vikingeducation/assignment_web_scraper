require 'csv'


class CSVMaker

def initialize(scraper)
  @scraper = scraper
  @jobs = scraper.jobs
  @keys = @jobs[0].keys
end

def create_csv
  CSV.open('jobs_file.csv', 'a') do |csv|
    #first row column headings
    headings = []
    @keys.each do |key|
      headings << key
    end
    csv << headings
    @jobs.each do |hash|
      job_row = []
      hash.each_value do |value|
        job_row << value
      end
      csv << job_row
    end
    #add our rows
  end
end

end