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

# with the new Mech object we get the job search page

page = agent.get( 'https://www.dice.com/jobs' )

# with this page we need to fill in the job search and location
form = page.forms

form.first do | f |

	job_type = f.field_with( :id => 'job' )
	job_type.value = 'Ruby'
	location = f.field_with( :id => 'location' )
	location.value = 'Chicago, IL'

end.submit




#job_type = form( 'q' )
#location = form( 'l' )
# form.fields.each { | f | puts f.name }
#job_type.q = 'Ruby'
#location.l = 'Chicago, IL'



# {buttons [button:0x3ffaa96f51d8 type: button name:  value: Find Tech Jobs]}>

pp form

# once those are filled we submit the form

# the returned form should have the first page of results which we then sift through



# prints out the links on the page
#page.links.each do | link |

#	puts link

#end

#pp page


# find a form and print out it's fields
# on Dice, this is the job search fields and button



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