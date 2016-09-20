require 'pry'
require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'nokogiri'


class Dice

	def initialize

		@results = nil

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
		jobs = @results.search("div.serp-result-content")
		# split the jobs up taking only the first 30
		# only if more than 30

		binding.pry

	end
	# each job search is in a div class="complete-serp-result-div" and the entire job search is in class="serp-result-content"

	# pagination is in the div id="dice_paging_btm"
	# or div class="dice_paging_top" with li and title="Go to page #" text is a number
	# class = "pagination"


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

dice.search( 'Ruby', 'Chicago, IL')

#dice.render_results

#dice.render_links

dice.render_page

dice.pull_job_list











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