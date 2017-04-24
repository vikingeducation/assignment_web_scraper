require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

agent = Mechanize.new
agent.history_added = proc { sleep 0.5 }

page = agent.get('http://www.dice.com/')

dice_form = page.form_with(action: '/jobs')
dice_form.q = 'ruby fullstack'
dice_form.l = '98019'

page = agent.submit(dice_form, dice_form.buttons.first)

page_data = []

page.links_with(href: /https:\/\/www.dice.com\/jobs\/detail\//).each do |link|
  page_data << link.href
end

job_details = []
page_data.each do |detail_page|
  page = agent.get(detail_page)
  job_info = []
  job_info << page.search("//h1[@class='jobTitle']").text  # job title
  job_info << page.search("//a[@id='companyNameLink']").text # company name
  job_info << page_data[0].match('(.+?)\?').captures[0]  # URL to detail
  job_info << page.search("//li[@class='location']").text  # location of job
  job_posting_time = page.search("//title").text    # posted
  job_info << job_posting_time.match('(\d\d-\d\d-\d\d\d\d)').captures[0]
  job_info << page_data[0].match('.+\/(.+?)\/.+?\?').captures[0] # company ID
  job_info << page_data[0].match('.+\/(.+?)\?').captures[0] # job id
  job_details << job_info
end



CSV.open('dice_file.csv', 'a') do |csv|
#    # each one of these comes out in its own row.
  job_details.each do |job_info|
    csv << job_info
  end    
end
