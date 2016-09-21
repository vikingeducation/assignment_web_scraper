require 'pry'
#require 'rubygems'
require 'mechanize'
#require 'open-uri'
require 'nokogiri'
require 'csv'


Job = Struct.new( :title, :company, :link, :location, :post_date, :company_id, :job_id )

class Dice

	def initialize

		@results = nil

		@jobs_array = []

		a = Mechanize.new { |agent|
		    agent.user_agent_alias = 'Mac Safari'
		}

		a.history_added = Proc.new { sleep 0.5 }

		url = 'https://www.dice.com/jobs'

		@page = a.get( url )

	end


	def search( job, location )

		search = @page.forms.first

		search.q = job
		search.l = location

		@results = search.submit

	end


	def pull_job_list

		# pulls all results from page
		job_list = @results.search("div.serp-result-content")

		parse( job_list )

	end


	def parse( list )

		list.each do | job |

			node = job.css("h3 a")[ 0 ]

			title, link = node[ 'title' ], node['href']

			company = job.css('ul a').children[0].text

			location = job.css('li')[ 1 ].text

			company_id = job.css('li a')[ 0 ][ 'href' ].match(/company\/(.*?)$/)[1]

			# check the link var for the position id using the company id as reference
			job_id = link.match(/#{company_id}\/(.*?)\?/)[ 1 ]

			post_date = calc_post_date( job.css( 'ul li' )[ 2 ].text )


			@jobs_array << Job.new( title, company, link, location, post_date, company_id, job_id )


		end


	end


	def calc_post_date( text )

		current_time = Time.now

		time_to_subtract = text.scan(/\d/).join.to_i

		if text.include?('hour')

			return ( current_time - ( 360 *time_to_subtract ) ).asctime

		elsif text.include?('week')

			 return ( current_time - ( 360 * 24 * 7 * time_to_subtract ) ).asctime

		elsif text.include?('month')
			# what would be the way to get the right days in the month?
			 return ( current_time - ( 360 * 30 * 24 * time_to_subtract ) ).asctime

		elsif text.include?('year')

			 return ( current_time - ( 360 * 24 * 365 * time_to_subtract ) ).asctime

		end

	end


	def render_results

		pp @results

	end


	def render_page

		pp @page

	end


	def create_csv

		column_header = [ "Title", "Company", "Link", "Location", "Post Date", "Company ID", "Position ID"]

		CSV.open('dice_job.csv', 'a', :write_headers => true, :headers => column_header ) do | csv |

			@jobs_array.each do | job |

				csv << job

			end

		end

	end


end

dice = Dice.new

dice.search( 'Java', 'Chicago, IL')

#dice.render_results

#dice.render_page

dice.pull_job_list

dice.create_csv




