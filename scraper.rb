# /scraper.rb
require 'rubygems'
require 'mechanize'

# Job Struct
Job = Struct.new(:title, :comp, :link, :loc, :date, :comp_id, :job_id)

# Create scraper
agent = Mechanize.new
agent.history_added = Proc.new {sleep 0.5}

# def get_job_info(link, job, agent)
#   job.link = link.href
#   testy = agent.get(link)
#   capt_group = testy.at('title').text.match(%r{(.*)\s-\s(\w+)\s-\s(.+\,\s[A-Z]{2})\s-\s(\d{2}-\d{2}-\d{4})})
#   job.title = capt_group[1]
#   job.comp = capt_group[2]
#   job.loc = capt_group[3]
#   job.date = capt_group[4]
# end
# global variables
job_site = "http://www.dice.com"
output = []
fail_count = 0

# Submit the search criteria
agent.get(job_site)
page = agent.get(job_site)
form = page.form_with(:action => "/jobs")
form.q = 'Ruby'
form.l = 'Washington, DC'
job_links = agent.submit(form, form.buttons.first)
job_links.links_with(:href => %r{/jobs/detail/}).each do |link|
  current_job = Job.new
  job_page = link.click
  # get_job_info(job_page, current_job, agent)

  capt_group = job_page.at('title').text.match(%r{(.+) - (.+) - (.+) - (\d{2}-\d{2}-\d{4})})
  if capt_group
    current_job.title = capt_group[1]
    current_job.comp = capt_group[2]
    current_job.loc = capt_group[3]
    current_job.date = capt_group[4]
    output << current_job
  else
    puts "Failure at #{job_page.at('title').text}"
    fail_count += 1
  end
end

puts output
puts fail_count


test_link = agent.get("https://www.dice.com/jobs/detail/Ruby-on-Rails-Developer-%281099-Remote%29-ByteCubed-Crystal-City-VA-22202/90744032/008112?icid=sr1-1p&q=ruby&l=Washington,%20DC")
test_job = Job.new


# get_job_info(test_link, test_job)
# puts test_job
# puts "what"



# def extract_data(string)
#
#
# end


# puts results

# Scrape the results page(s)

# Add the results as struts?

# append results.csv document
