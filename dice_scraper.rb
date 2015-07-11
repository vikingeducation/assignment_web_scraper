# require "rubygems"
# require "nokogiri"
# require "open-uri"
require "mechanize"
require "csv"

def calculate_date(time)
  # Method to calculate the date from the relative time string provided

  # Split string into array
  arr = time.split(" ")

  # arr[0] is the value, convert to int
  time_value = arr[0].to_i

  # arr[1] is the period (seconds, minutes, hours, days, weeks, months, or years)
  period = arr[1]

  period_in_seconds = 0

  case period
  when period.include?("second")
    period_in_seconds = period
  when period.include?("minute")
    period_in_seconds = period * 60
  when period.include?("hour")
    period_in_seconds = period * 60 * 60
  when period.include?("day")
    period_in_seconds = period_in_secondsd * 60 * 60 * 24
  when period.include?("week")
    period_in_seconds = period * 60 * 60 * 24 * 7
  when period.include?("month")
    period_in_seconds = period * 60 * 60 * 24 * 7 * 30
  when period.include?("year")
    period_in_seconds = period * 60 * 60 * 24 * 7 * 30 * 12
  end

  # Get current time
  current_time = Time.now

  # Get difference between current time and post time
  post_time = current_time - (time_value * period_in_seconds)


end

agent = Mechanize.new

page = agent.get('http://www.dice.com')

search_form = page.form(:id => "search-form")

search_form.q = "ruby web developer"

results = search_form.submit

job_elements = results.search("div[@class='serp-result-content']")

job_elements.each do |job|
  job_link = job.at_css("h3 a").attributes["href"].value
  job_title = job.at_css("h3").text.strip
  company_name = job.at_css("li[@class = employer]").text
  location = job.at_css("li[@class = location]").text
  time = calculate_date(job.at_css("li[@class = posted]").text)

end


CSV.open('job_list.csv', 'a') do |csv|

  # Get job title
  # Company name
  # Link to posting on dice
  # Location
  # Posting date
  # Company ID
  # Job ID
end


