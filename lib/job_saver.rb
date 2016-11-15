class JobSaver

  def save(path, jobs)
    if File.file?(path)
      file = CSV.open(path, 'a+')
      add_header(file)
    else
      file = CSV.open(path, 'a+')
    end
    jobs.each do |job|
      add_job(file, job, path)
    end
  end

  def add_header(file)
    file << ["Title", "Job Link", "Employer", "Location", "Company ID", "Job ID", "Posted at"]
  end

  def add_job(file, job, path)
    unless contains?(path, job)
      file << [job.title, job.job_link, job.employer, job.location, job.company_id, job.job_id, job.posted]
    end
  end

  def contains?(path,job)
    contains = false
    CSV.foreach(path) do |row|
      if row[5] == job.job_id
        contains = true 
      end
    end
    contains
  end
end