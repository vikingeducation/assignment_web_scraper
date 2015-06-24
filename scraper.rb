require 'rubygems'
require 'bundler/setup'
require 'mechanize'


Result = Struct.new(:job_title, :company, :link, :location, :post_date, :company_id, :job_id)


#class DiceScraper < Mechanize

#end

agent = Mechanize.new
agent.history_added = Proc.new { sleep 0.5 }

page = agent.get('https://www.dice.com/jobs')

search_form = page.form_with(:id => 'searchJob')

# Job title or keywords
search_form.q = "Web developer"

# Location ~ City, ST
search_form.l = "Boston, MA"

page = agent.submit(search_form)


# grab each link and click on it
  # in div class="serp-result-content" > h3 > a
result_links = page.search("div.serp-result-content h3 a")

array = []

result_links.each do |result|

  begin
    agent.transact do
      result_page = agent.click(result)

      job_title = result_page.at("h1#jt").text

      company = result_page.at("li.employer").text.strip

      link = result_page.uri.to_s

      location = result_page.at("li.location").text

      post_date = result_page.at("li.posted").text

      company_id = result_page.body.match(/.*Dice Id : (.*)<\/div>/)[1].strip

      job_id = result_page.body.match(/.*Position Id : (.*)<\/div>/)[1].strip


      array << Result.new(job_title, company, link, location, post_date, company_id, job_id)

    end

  rescue => e
    $stderr.puts "#{e.class}: #{e.message}"
  end

end

puts array