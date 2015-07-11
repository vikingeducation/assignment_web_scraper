require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'bundler/setup'
require 'mechanize'

JobPosting = Struct.new(:title, :co_name, :post_link,
							:location, :post_date, :co_ID, :job_ID)

class GetJobPage
	def scrape
		@b = Mechanize.new
		@b.history_added = Proc.new { sleep 0.5 }
		parsed_page = submit_search(get_page(@b))
		process_search_results(parsed_page)
	end

	def get_page(b)
		@b.get("http://www.dice.com/")
	end

	def submit_search(page)
		submit_query = page.form(:id => 'search-form')
		submit_query.q = "Ruby on Rails"
		submit_query.l = "San Francisco, CA"
		result = @b.submit(submit_query, submit_query.button)
		result.parser
	end

	def process_search_results(parsed_page)
		parsed_page.css("div .serp-result-content")
	end
end
