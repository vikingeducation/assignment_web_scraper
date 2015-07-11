require_relative './dice.rb'
require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'
require 'time'

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
				csv << [title(job), co_name(job), post_link(job),
						location(job)]
			end
		end
	end

	def test
		title
	end

	def title(job)
		job.css("a").first.text.strip
	end

	def co_name(job)
		job.css("li a").first.children.text
	end

	def post_link(job)
		job.css("h3 a").first.attr('href')
	end

	def location(job)
		job.css("li")[1].text
	end

	def post_date
		posting_sched = job.css("li")[2].text
		time = time.now
		day = time.day
		month = time.month
		year = time.year

		if posting_sched.include?("day") || posting_sched.include?("days")
			posting_day = posting_sched.match(/\d/)
			day = day - posting_day[0].to_i
			"Post date: #{month}/#{day}/#{year}"
		elsif posting_sched.include?("week") || posting_sched.include?("weeks")
			posting_week = posting_sched.match(/\d/)
			week = week - posting_day[0].to_i
			"Post date: #{month}/#{day}/#{year}"
		elsif posting_sched.include?("month") || posting_sched.include?("months")

		else
			"Post date: #{month}/#{day}/#{year}"
		end
	end

	def company_id

	end

	def job_id

	end

end