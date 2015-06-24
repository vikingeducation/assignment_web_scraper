require 'rubygems'
require 'bundler/setup'
require 'mechanize'


Result = Struct.new(:job_title, :company, :link, :location, :post_date, :company_id, :job_id)


agent = Mechanize.new
agent.history_added = Proc.new { sleep 0.5 }

page = agent.get('https://www.dice.com/jobs')

search_form = page.form_with(:id => 'searchJob')

# Job title or keywords
search_form.q = "Web developer"

# Location ~ City, ST
search_form.l = "Boston, MA"

page = agent.submit(search_form)


# grab each link and click on it
  # in div class="serp-result-content" > h3 > a
result_links = page.search("div.serp-result-content h3 a")

next_page = result_links.first
result_page = agent.click(next_page)


# Job title
#    -> div id="header-wrap" > h1 id="jt"
job_title = result_page.at("h1#jt").text

# Company name
#    ^ + li class="employer"
company = result_page.at("li.employer").text.strip

# Link to posting on Dice
#    -> current page
link = result_page.uri.to_s

# Location
#    ^ + li class="location"
location = result_page.at("li.location").text

# Posting date (not a relative date like "x weeks ago" because that will quickly be meaningless)
#    ^ + li class="posted" (compare to current date)
post_date = result_page.at("li.posted").text

# Company ID
#    -> div class="company-header-info" 2nd "row"
company_id = result_page.body.match(/.*Dice Id : (.*)<\/div>/)[1].strip

# Job ID
#    -> div class="company-header-info" 3rd "row"
job_id = result_page.body.match(/.*Position Id : (.*)<\/div>/)[1].strip


result_data = Result.new(job_title, company, link, location, post_date, company_id, job_id)
p result_data