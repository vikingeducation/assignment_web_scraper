require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

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
    csv_writer(results)
  end

  def get_page(terms, location)
    results = nil
    done = false
    jobs = []
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
          current_job.company_id = link.href.split("/")[6]
          current_job.post_id = link.href.split("/")[7].split("?")[0]

          jobs << current_job
          done = true
        else
          done = false
        end # unless
      end # links_with
    end # agent
    jobs
  end # get_page method

  def csv_writer(results)
    input = convert_struct(results)

    CSV.open('jobs.csv', 'a', :write_headers => true,
      :headers => ["Job Title", "Company", "Location", "Date Posted", "Company ID", "Post ID", "URL"]) do |csv|
      input.each do |row|
        csv << row
      end
    end
  end

  def convert_struct(results)
    results_array = []

    results.each_with_index do |struct|
      results_row = []
      struct.each do |item|
        results_row << item
      end
      results_array << results_row
      # results_array << [struct.title, struct.company, struct.location. struct.date, struct.company_id, struct.post_id, struct.url]
    end

    results_array
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
