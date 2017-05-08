require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

agent = Mechanize.new {|a| a.user_agent_alias = 'Windows Chrome'}
agent.history_added = Proc.new {sleep 0.5}
page = agent.get('https://www.dice.com/jobs/advancedResult.html?for_one=ruby&for_all=&for_exact=&for_none=&for_jt=junior&for_com=&for_loc=Washington%2C+DC&sort=relevance&limit=100&radius=0&searchid=6054073227719')

def posted_on(date_text)
  word_arr = date_text.split(" ")
  case word_arr[1]
  when "minute", "minutes"
    dif = word_arr[0].to_i * 60
  when "hour", "hours"
    dif = word_arr[0].to_i * 3600
  when "day", "days"
    dif = word_arr[0].to_i * 86400
  else
    dif = 0
  end
  return Time.now - dif
end

CSV.open('job_file.csv', 'a') do |csv|
  page.parser.css(".complete-serp-result-div").each do |ad|
    csv << [(ad.at_css(".serp-result-content h3 a")['title']), ( ad.at_css(".employer span[2]")['title']), (ad.at_css(".serp-result-content h3 a")['href']), (posted_on(ad.at_css(".posted").text)), (ad.at_css(".serp-result-content input")['id']), (ad.at_css(".serp-result-content h3 a")['value']), (ad.at_css(".location")['title'])]
  end
end
