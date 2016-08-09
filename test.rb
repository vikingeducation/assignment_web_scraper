require 'mechanize'

Job = Struct.new :title, :company, :salary, :description

search_page = 'https://www.liepin.com/zhaopin/'

agent = Mechanize.new do |agent|
  agent.user_agent_alias = 'Windows Chrome'
end

page = agent.get(search_page)
results = page[0].form do |search|
  search.key = 'rails'
  search.dqs = '010' # City Beijing
end.submit
link = results.links_with(:href => /job.liepin.com\/(\d){3}_(\d){7}/ )
current_job = Job.new
# Get job title
current_job.title = link.text.strip
# Go to the job describtion page
description_page = link.click
