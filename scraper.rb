require 'pry'
require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'nokogiri'

# search form is q
# location is l ( city, state, zip )
# check boxes
	# Full-Time : jtype=Full+Time
	# Part-Time : jtype=Part+Time
	# Contracts : jtype=Contracts
	# Third Party : jtype=Third+Party
	# Telecommute : dtco-true
	# Radius : limit-##
		# zip-radius-##-jobs
	# Company Segment ( either or )
		# Recruiter : zip-dcs-Recruiter-radius...
		# Direct Hire : dcs-DirectHire-radius...

a = Mechanize.new { |agent|
    agent.user_agent_alias = 'Mac Safari'
}
# this gives your Mechanize object
# an 0.5 second wait time after every HTML request
# Don't forget it!!!
a.history_added = Proc.new { sleep 0.5 }

# with the new Mech object we get the job search page

page = a.get( 'https://www.dice.com/jobs' )



form = page.forms.first

form.q = 'Javascript'
form.l = 'Peoria, IL'



# results stored here upon submission
results = form.submit



pp results
# with this page we need to fill in the job search and location



# {buttons [button:0x3ffaa96f51d8 type: button name:  value: Find Tech Jobs]}>




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