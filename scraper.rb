require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'


Result = Struct.new(:job_title, :company, :link, :location, :post_date, :company_id, :job_id)

in_hours = {minute: 0, hour: 1, day: 24, week: 168, month: 720}


agent = Mechanize.new
agent.history_added = Proc.new { sleep 0.5 }

page = agent.get('https://www.dice.com/jobs')

search_form = page.form_with(:id => 'searchJob')

search_form.q = "Web developer"
search_form.l = "Boston, MA"

page = agent.submit(search_form)

# sort by date
page = page.link_with(:id => "sort-by-date-link").click


result_content = page.search("#search-results-control .serp-result-content")


result_content.each_entry do |result|
  job_title = result.at_css("h3 a").text.strip
  company = result.at_css("li.employer").text
  link = result.at_css("h3 a").attributes["href"].value
  location = result.at_css("li.location").text

  posted = result.at_css("li.posted").text
  parse_time = posted.match(/(\d.*?)\s(.*?)s?\s/i)

  if parse_time.nil?
    hours_since_post = 0
  else
    hours_since_post = parse_time[1].to_i * in_hours[parse_time[2].downcase.to_sym]
  end

  post_date = (Time.now - hours_since_post*60*60).to_date.to_s

  ids = link.match(/dice.com(?:\/.*?){3}\/(.*?)\/(.*?)\?/)
  company_id = ids[1]
  job_id = ids[2]

  CSV.open('results.csv', 'a') do |csv|
      # each one of these comes out in its own row.
      csv << [job_title, company, link, location, post_date, company_id, job_id]
  end

end

=begin
      result_page = agent.click(result)

end
=end