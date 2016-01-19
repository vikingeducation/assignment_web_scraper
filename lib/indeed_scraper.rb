require_relative 'scraper.rb'

class IndeedScraper < DiceScraper
  attr_reader :jobs

  def search_for(query, zipcode)
    query = query.split(" ").join("+")
    @agent.get("http://www.indeed.com/jobs?q=#{query}&l=#{zipcode}")
  end

  def scrape_jobs(query, zipcode)
    page = search_for(query, zipcode)
    count = 1

    while next_page = next_page?(page)
      puts "Searching page # #{count}"
      job_nodes = get_job_nodes(page)
      job_nodes.each do |job_node|
        new_job = job_from_node(job_node)
        @jobs << new_job
      end
      count += 1
      page = next_page.click
    end
  end

  def next_page?(page)
    page.link_with(text: /Next/)
  end

  def get_job_nodes(page)
    page.css(".result")
  end

  def job_from_node(job_node)
    title = job_node.at(".jobtitle").text # job title
    puts title
    link = job_node.at(".jobtitle").attributes["href"].value # link to posting on dice
    company = job_node.at(".company").text # company name
    location = job_node.at(".location").text # location
    date = Chronic.parse(job_node.at(".date").text) # date of posting
    Job.new(title: title, company: company, link: link, location: location, date: date)
  end
end

scraper = IndeedScraper.new
scraper.scrape_jobs("Ruby on Rails", 91125)
filter = Filter.new(date: "1 day ago", title: "Developer")
jobs = filter.filter_jobs(scraper.jobs)
JobSaver.new(jobs).save_to_csv