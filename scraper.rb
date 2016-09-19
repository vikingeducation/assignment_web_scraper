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

agent = Mechanize.new { |agent|
    agent.user_agent_alias = 'Mac Safari'
}
# this gives your Mechanize object
# an 0.5 second wait time after every HTML request
# Don't forget it!!!
agent.history_added = Proc.new { sleep 0.5 }



page = agent.get( 'https://www.dice.com/jobs' )

# prints out the links on the page
#page.links.each do | link |

#	puts link

#end

#pp page


# find a form and print out it's fields
# on Dice, this is the job search fields and button
form = page.forms.first
form.fields.each { | f | puts f.name }


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