require 'mechanize'
require 'csv'

Job = Struct.new(:title, :company, :link, :location, :post_date, :company_id, :job_id)

found_jobs = []

scraper = Mechanize.new do |agent|
  agent.user_agent_alias = 'Mac Safari'
  agent.history_added = Proc.new { sleep 0.5 } # just in case
end

scraper.get('http://www.dice.com/') do |page|
  search_result = page.form_with(action: '/jobs') do |search|
    search.q = 'software engineer'
  end.submit # performing the search from the homepage

  # crawling each link, getting the info & making new jobs
  search_result.links_with(href: /jobs\/detail/).each do |link|
    current_job = Job.new

    current_job.title = link.text.strip
    current_job.link = link.uri.to_s

    description_page = link.click

    current_job.company = description_page.search('.employer').text.strip
    current_job.location = description_page.search('.location').text.strip
    current_job.post_date = description_page.search('.posted').text.strip
    current_job.company_id = description_page.search("//*[@id='bd']/div/div[2]/div[1]/div[1]/div").text.gsub('Dice Id : ', '')
    current_job.job_id = description_page.search("//*[@id='bd']/div/div[2]/div[1]/div[2]/div").text.gsub('Position Id : ', '')

    found_jobs << current_job
  end
end

CSV.open('test_jobs.csv', 'a') do |csv|
  found_jobs.each { |job| csv << [ job.title, job.company, job.link, job.location, job.post_date, job.company_id, job.job_id] }
end