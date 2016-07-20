require 'csv'


class CSVMaker

attr_reader :name
def initialize(scraper)
  @scraper = scraper
  @jobs = scraper.jobs
  @keys = @jobs[0].keys
  @name = ""
end

def random_name
  8.times {@name << (65+rand(25)).chr}
  @name << ".csv"
  @name
end

def create_csv
  CSV.open(random_name, 'a') do |csv|
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