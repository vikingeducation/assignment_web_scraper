
class JobSaver

  def save(path, jobs)
    file = CSV.open(path, 'a+')
    add_header(file) if File.zero?(file)
    jobs.each do |job|
      add_job(file, job)
    end
  end

  def add_header(file)
    file << ["Title", "Job Link", "Employer", "Location", "Company ID", "Job ID", "Posted at"]
  end

  def add_job(file, job)
    file << [job.title, job.job_link, job.employer, job.location, job.company_id, job.job_id, job.posted]
  end
end