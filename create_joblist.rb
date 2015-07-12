require_relative './dice.rb'
require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'
require 'Date'

class WriteJobs
	attr_accessor :job_search_results

	def initialize
		a = GetJobPage.new
		@job_search_results = a.main
	end

	def create_arr_of_job_entries
		# @job_search_results.each do |j|
			@job_search_results.each_with_index do |job, i|
				CSV.open('csv_file.csv', 'a') do |csv|
					csv << [title(job), co_name(job), post_link(job),
							location(job), company_id(job), job_id(job), post_date(job)]
				end
			end
	end

	def title(job)
		job.css("a").first.text.strip if job.css("a").first != nil
	end

	def co_name(job)
		job.css("li a").first.children.text if job.css("li a").first != nil
	end

	def post_link(job)
		job.css("h3 a").first.attr('href') if job.css("h3 a").first != nil
	end

	def location(job)
		job.css("li")[1].text if job.css("li")[1] != nil
	end

	def post_date(job)
		posting_sched = job.css("li")[2].text if job.css("li")[2] != nil
		date = Date.today
		if posting_sched.include?("day")
			posting_day = posting_sched.match(/\d/)
			"Post date: #{date - posting_day[0].to_i}"
		elsif posting_sched.include?("week")
			posting_week = posting_sched.match(/\d/)
			"Post date: #{date - posting_week[0]*7}"
		elsif posting_sched.include?("month")
			posting_month = posting_sched.match(/\d/)
			"Post date: #{date.prev_month(posting_month)}"
		else
			"Post date: #{date}"
		end
	end

	def company_id(job)
		link = job.css("h3 a").first.attr('href') if job.css("h3 a").first != nil
		com_id_string = link.match(/(?<=[0-9]\/)([a-zA-Z]||[0-9]).*(?=\/)/)
		com_id_string[0]
	end

	def job_id(job)
		link = job.css("h3 a").first.attr('href') if job.css("h3 a").first != nil
		job_id_string = link.match(/(?<=\/)([A-Z]|[0-9])+([A-Z]|[0-9])+.*(?=\?)/)
		exact = job_id_string[0].split("/") if job_id_string[0].include?("/")
		exact != nil ? exact[1] : job_id_string[0]
	end

end