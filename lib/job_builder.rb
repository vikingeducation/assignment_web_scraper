class JobBuilder < Mechanize
  def build_jobs(jobs)
    jobs.map{ |job| build(job) }
  end
end

class DiceBuilder < JobBuilder

  def build(job_div)
    title = job_div.search("h3 a").attr("title").value
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

class IndeedBuilder < JobBuilder

  def build(job_div)
    title = job_div.search("a").first.attr("title")
    job_link = job_div.search("a").first.attr("href")
    employer = job_div.search(".company").text.strip
    location = job_div.search(".location").text.strip
    job_id = job_div.attr("id")
    posted_string = job_div.search(".date").text.strip
    if posted_string == "30+ days ago"
      posted = "Before #{Date.today - 30}"
    else 
      posted = Chronic.parse(job_div.search(".date").text)
    end
    Job.new(title, job_link, employer, location, nil, job_id, posted)
  end
end