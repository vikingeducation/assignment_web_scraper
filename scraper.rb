require 'rubygems'
require 'bundler/setup'
require 'mechanize'

# scraper = Mechanize.new
# scraper.history_added = Proc.new { sleep 1.0 }

# https://www.dice.com/jobs?q=job&l=Philadelphia%2C+PA&searchid=1651350807861

# https://www.dice.com/jobs/q-ruby-limit-99-startPage-2-limit-99-jobs?searchid=9637969994242

Job = Struct.new(:title, :company, :location, :date, :company_id, :post_id, :url)

class Dice < Mechanize
  def initialize(terms, location="")
    @agent = Mechanize.new
    run(terms, location)
  end

  def run(terms, location)
    @agent.history_added = Proc.new { sleep 1.0 }
    results = get_page(terms, location)
    render(results)
  end

  def get_page(terms, location)
    results = nil
    done = false
    array_of_jobs = []
    page_one = @agent.get("https://www.dice.com/jobs?q=#{terms}&l=#{location}&limit=5") do |page|
      page.links_with(:id => /position/).each do |link|
        unless done
          current_job = Job.new
          current_job.url = link.href
          current_job.title = link.text.strip
          job_page = link.click
          current_job.company = job_page.search('li.employer>a').children[0].text
          current_job.location = job_page.search('li.location').children[0].text
          current_job.date = job_page.search('title').children[0].text.split(" ")[-3]
          done = true
        else
          done = false
        end
      end
    end
  end

  def render(results)
    results.each do |result|
      # p result.text.strip
      # p result.href
    end
  end
end

Dice.new("ruby developer")



# # date posted
# title
# # look for year 2016, capture 6 digits before it
# # 11-11-2016
# # company id
# array = href.split("/")
# array[6]
# # post id
# array[7].split("?")[0]
