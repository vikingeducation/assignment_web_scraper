require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

def date_parser(date)
  # match for minutes, hours, days, or weeks
  # match for the number
  # format properly to be subtracted from Time.now
  units = date.match(/(moments|minutes|hours|days|weeks|months)/)[0]
  number = date.match(/\d+/)[0].to_i
  result = case units
  when "moments"
    0
  when "minutes"
    number * 60
  when "hours"
    number * 3600
  when "days"
    number * 86_400
  when "weeks"
    number * 86_400 * 7
  when "months"
    number * 86_400 * 30
  end

  "Posted around #{Time.now - result}"
end
# Instantiate a new Mechanize
scraper = Mechanize.new

scraper.history_added = Proc.new { sleep 0.5 }

# Grab and parse our page in one step
# like we did with Nokogiri and open-uri
page = scraper.get('https://www.dice.com/jobs/advancedResult.html?for_one=Ruby&for_all=&for_exact=&for_none=&for_jt=&for_com=&for_loc=New+York%2C+NY&sort=relevance&limit=50&radius=0')


search_results = page.search('.serp-result-content')
p search_results.count

pp search_results[1].css('h3').text.strip
pp search_results[1].css("[id*='company']")[1].text
p link = search_results[1].css('a[id*="position"]').map { |link| link['href'] }[0]
pp search_results[1].css("li.location").text
pp date_parser(search_results[1].css("li.posted").text)
link = search_results[1].css('a[id*="position"]')[0]

posting_page = scraper.get(search_results[1].css('a[id*="position"]').map { |link| link['href'] }[0])





# Grab the form of class="f" from the page
# job_div = page.div(:class => "serp-result-content")

# Grab the form by ID or action
# another_form = page.form_with(:id => "some-id")
# another_form = page.form_with(:action => "/some_path")

# # Fill in the field named "q" (Google's search query)
# job_div.q = 'ruby mechanize'

# # Actually submit the form
# page = scraper.submit(job_div)

# # Print out the page using the "pretty print" command
# pp page