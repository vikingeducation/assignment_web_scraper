require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'pry'

require 'csv'

def initialize


end
#site we're visiting
def scrape_page(url)

end

agent = Mechanize.new

  #mechanize object waits 0.5secs after every HTML request
agent.history_added = Proc.new { sleep 0.5 }


page = agent.get('http://www.dice.com')

#where the search leads us to
dice_search_page = "http://www.dice.com/jobs"

results_page = nil
#sends submits search input into form
agent.get(dice_search_page) do |page|
  results_page = page.form_with(:name => nil) do |search|
      search.q = 'junior developer'
      search.l = 'New York, NY'
  end.submit

end

#results_page
#binding.pry
noko_tree = results_page.parser

job_list = noko_tree
job_arr = []
scrape_job_post
def scrape_job_post
  job_list.each do |job|
    #click on post for ID
    company_id, job_id = search_IDs(link)
    employer = job.css("li.employer").text
    title = job.css("h3 a").text.strip
    link = job.css("h3 a").attribute("href").value
    location = job.css("li.location").text
    date_posted = date_conversion(job.css("li.posted").text)
    job_arr << [company_id, job_id, employer,title, link, location, date_posted]
  end
end

def search_IDs(link)
  binding.pry
  post_page = agent.results_page.link_with(:href => link)
  tree = post_page.parser
  company_id = nil
  job_id =nil
  company_node = tree.css("div.company-header-info")
  company_node.each do |node|
    if node.content.include?("Dice Id : ")
      company_id = node.text.strip
    elsif node.content.include?("Position Id : ")
      job_id = node.text.strip
    end
  end
  return company_id, job_id
end



def date_conversion(date_str, time_of_scraping = Time.new(2015, 7, 11, 17, 8, 2, "-04:00"))
  date_str.split!(" ")
  words_to_date(time_of_scraping) unless time_of_scraping.is_a?(Time)
  date = date_str[0].to_i * words_to_date(date_str[1])
end

def words_to_date(word)
  case word
  when "hours"
    60*60
  when "days"
    60*60*24
  when "weeks"
    60*60*24*7
  end
end

#pp page

=begin
job_post = div.serp-result-content
  h3, a [href] = link to post
      a = job title
  li.employer, a = company name
  li.location = location
  li.posted = post date rel. to today

to actual post page
div.company-header-info
company id: starts with "Dice ID : "
job id: starts with "Position Id : "


job_title = results.page.parser.css("div#serp div.serp-result-content h3 a")
=end

# just strings
#ex: CSV.open('some_csv_file.csv', 'a') do |csv|
#      csv << #put stuff in one row, array of string ok
#      csv << #put stuff in another row
#    end
#note: .gitignore output csv file