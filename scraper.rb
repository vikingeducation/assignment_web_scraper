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

			position_id = link.match(/#{company_id}\/(.*?)\?/)[ 1 ]

binding.pry
		end

#company id 10111030
#position id 70902

	end
	# Xpath //*[@id="company0"]



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