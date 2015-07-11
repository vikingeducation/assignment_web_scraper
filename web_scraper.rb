require 'rubygems'
require 'bundler/setup'
require 'mechanize'

require 'csv'


agent = Mechanize.new

#mechanize object waits 0.5secs after every HTML request
agent.history_added = Proc.new { sleep 0.5 }

#site we're visiting
page = agent.get('http://www.dice.com')

#where the search leads us to
dice_search_page = "http://www.dice.com/jobs"

#sends submits search input into form
agent.get(dice_search_page) do |page|
  results = page.form_with(:name => nil) do |search|
      search.q = 'developer'
      search.l = 'New York, NY'
  end.submit

  #prints out results of search page by link
  results.links.each do |link|
    puts link.text
  end

  #pp page
end

#ex: CSV.open('some_csv_file.csv', 'a') do |csv|
#      csv << #put stuff in one row
#      csv << #put stuff in another row
#    end
#note: .gitignore output csv file