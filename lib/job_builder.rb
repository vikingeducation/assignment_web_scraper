class JobBuilder < Mechanize
  def build_jobs(jobs)
    jobs.map{ |job| build(job) }
  end

  def build(job_div)
    title = job_div.search("h3 a").attr("title").value
    description = job_div.search(".shortdesc").text.strip
    employer = job_div.search("li.employer .hidden-xs").attr("title").value
    location = job_div.search("li.location").attr("title").value

    job_link = job_div.search("h3 a").attr('href').value
    link_parts = job_link.split("/")
    company_id = link_parts[6]
    job_id = link_parts[7].split("?")[0]
    posted = Chronic.parse(job_div.search("li.posted").text)
    Job.new(title, job_link, employer, location, company_id, job_id, posted)
  end
end