require_relative './dice.rb'
require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

class WriteJobs
	attr_accessor :job_search_results

	def initialize
		a = GetJobPage.new
		@job_search_results = a.scrape
	end

	def create_arr_of_job_entries
		@job_search_results.each_with_index do |job, i|
			CSV.open('csv_file.csv', 'a') do |csv|
				# csv << [title(job), co_name(job), post_link(job), location(job), post_date(job), job_id(job), company_id(job)]
				csv << [title(job)]
			end
		end
	end

	def test
		title
	end

	def title(job)
		job.css("a").first.text.strip
	end

	def co_name

	end

	def post_link

	end

	def location

	end

	def post_date

	end

	def company_id

	end

	def job_id

	end

end