require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'csv'

agent = Mechanize.new
agent.history_added = Proc.new { sleep 0.5 }


page = agent.get('http://www.dice.com/')
page_form = page.form_with(:action => '/jobs')
#pp page_form
page_form.q = "Ruby on Rails"
page_form.l = "New York"
result = page_form.submit
#pp result
joblist = result.links_with :href => /jobs\/detail\//
#pp joblist
#job1 = joblist[0].click
#pp job1
=begin
Job title---------
Company name----------
Link to posting on Dice----------
Location-----------
-----Posting date (not a relative date like "x weeks ago" because that will quickly be meaningless)
Company ID
Job ID
=end
def savedata(array)
   CSV.open('scraper.csv', 'a') do |csv|
       csv << array
   end
end

joblist.each do |joblink|
    job = joblink.click
    jobId =  job.parser.css("meta[name = 'jobId']").attribute('content')
    jobTitle = job.parser.css("h1[class = 'jobTitle']").text
    companyName = job.parser.css("li a[class = 'dice-btn-link']").text
    jobLink = job.parser.css("link[rel = 'canonical']").attribute('href')
    location = job.parser.css("li[class = 'location']").text
    title = job.parser.css("title").to_s
    date = title.match(/- (\d+.+)\|/).captures
    companyId = job.parser.css("meta[name = 'groupId']").attribute('content')
    savedata([jobId, jobTitle,companyName, jobLink, location, title, date, companyId])
end






=begin
puts jobTitle
puts companyName
puts companyId
puts jobLink
puts jobId
puts date
puts location
=end
#pp test1