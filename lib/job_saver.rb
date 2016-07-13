class JobSaver
  def initialize(jobs)
    @jobs = jobs
  end

  def save_to_csv
    headers = ['Title', 'Company', 'Link', 'Location', 'Date', 'Company Id', 'Job Id']

    unless File.exist?('scraped_jobs.csv')
      CSV.open("scraped_jobs.csv", 'w') do |csv|
        csv << headers
      end
    end

    CSV.open("scraped_jobs.csv", 'a') do |csv|
      @jobs.each do |job|
        csv << job.to_a
      end
    end
  end
end
