require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'


Result = Struct.new(:job_title, :company, :link, :location, :post_date, :company_id, :job_id)


#class DiceScraper < Mechanize

#end

agent = Mechanize.new
agent.history_added = Proc.new { sleep 0.5 }

page = agent.get('https://www.dice.com/jobs')

search_form = page.form_with(:id => 'searchJob')

search_form.q = "Web developer"
search_form.l = "Boston, MA"

page = agent.submit(search_form)


# grab each link and click on it
  # in div class="serp-result-content" > h3 > a
result_content = page.search("div.serp-result-content")

#page.links_with(:id => /position.*/).text.strip

result_content.each_entry do |result|
  job_title = result.at_css("h3 a").text.strip
  company = result.at_css("li.employer").text
  link = result.at_css("h3 a").attributes["href"].value
  location = result.at_css("li.location").text

  post_date = result.at_css("li.posted").text

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