require 'csv' 

class CSVSaver

  def initialize(jobs) # array of Job structs
    @jobs = jobs
  end

  def save_csv
    CSV.open('csv_file.csv', 'a') do |csv|
      @jobs.each do |job|
        csv << entry(job)
      end
    end
  end

  def clear_csv
    CSV.open('csv_file.csv', 'w') { }
  end

  def entry(job)
    [job.title, job.company_name, job.link, job.location, job.post_date]
  end

end

