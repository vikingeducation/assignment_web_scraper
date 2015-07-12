require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'pry'

class GetJobPage
	attr_reader :array, :b

	def initialize
		@b = Mechanize.new
		@array = 0
	end

	def main
		# binding.pry
		@array << scrape
		[2,3].each do |i|
			@array << pagination(i)
		end
		@array								#[[scraped parsed nokogiri tree], [scraped parsed nokogiri tree], [scraped parsed nokogiri tree]]
	end

	def scrape
		@b.history_added = Proc.new { sleep 0.5 }
		parsed_page = submit_search(get_page)
		process_search_results(parsed_page)
	end

	def get_page
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

	def pagination(page_num)
		result = @b.get("https://www.dice.com/jobs/q-Ruby+on+Rails-sort-relevance-l-San+Francisco%2C+CA-radius-30-startPage-#{page_num}-limit-30-jobs.html")
		process_search_results(result.parser)
	end
end
