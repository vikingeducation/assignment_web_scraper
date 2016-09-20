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


	def render

		pp @results

	end


end

dice = Dice.new

dice.search( 'Ruby', 'Chicago, IL')

dice.render

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