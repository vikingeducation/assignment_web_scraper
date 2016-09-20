require 'pry'
require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'nokogiri'
require 'csv'


Job = Struct.new( :title, :company, :link, :location, :post_date, :company_id, :job_id )

class Dice

	def initialize

		@results = nil
		@job_list = nil

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

		# pulls all results
		@job_list = @results.search("div.serp-result-content")

		binding.pry

	end

	def parse

		jobs = []

		@job_list.each do | job |

			node = job.css("h3 a")[ 0 ]
			# <h3> <a title="job title"
			title, link = node[ 'title' ], node['href']
			company = job.css('ul a').children[0].text
			location = job.css('li')[ 1 ].text

			# grab the company id
			company_id = job.css('li a')[ 0 ][ 'href' ].match(/company\/(.*?)$/)[1]

			# check the link var for the position id using the company id as reference
			job_id = link.match(/#{company_id}\/(.*?)\?/)[ 1 ]

			post_date = calc_post_date( job.css( 'ul li' )[2].text )


			jobs << Job.new( title, company, link, location, post_date, company_id, job_id )
binding.pry

		end

	end


	def calc_post_date( text )

		current_time = Time.now

		time_to_subtract = text.scan(/\d/).join.to_i

binding.pry
		if text.include?('hour')

			return ( current_time - ( 60 * 60 *time_to_subtract ) ).asctime

		elsif text.include?('week')

			 return ( current_time - ( 60 * 60 * 24 * 7 * time_to_subtract ) ).asctime

		elsif text.include?('month')
			# what would be the way to get the right days in the month
			 return ( current_time - ( 60 * 30 * 24 * 60 * time_to_subtract ) ).asctime

		elsif text.include?('year')

			 return ( current_time - ( 60 * 60 * 24 * 365 * time_to_subtract ) ).asctime

		end

	end


	def render_results

		pp @results

	end


	def render_links

		@page.links.each do | link |

			puts link.text

		end

	end


	def render_page

		pp @page

	end

end

dice = Dice.new

dice.search( 'Java', 'Chicago, IL')

#dice.render_results

#dice.render_links

dice.render_page

dice.pull_job_list

dice.parse











#results = job_search_form.submit
#Full-Time - check box link
#page.link_with( :text => 'Full-Time' ).click
#Part-Time
# page.link_with( :text => 'Part-Time' ).click
#Contracts
# page.link_with( :text => 'Contracts' ).click
#Third Party
# page.link_with( :text => 'Third-Party' ).click


=begin

User-agent: *
Allow: /jobs
Allow: /dashboard
Allow: /register
Allow: /mobile
Allow: /company

Disallow: /admin
Disallow: /jobman
Disallow: /reports
Disallow: /talentmatch
Disallow: /profman
Disallow: /regman
Disallow: /ows
Disallow: /config
Disallow: /m2

Disallow: /jobsearch/
Disallow: /job

User-agent: Googlebot-News
Disallow: /

=end