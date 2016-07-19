require 'rubygems'
require 'bundler/setup'
require 'mechanize'

agent = Mechanize.new

agent.history_added = Proc.new { sleep 0.5 }

page = agent.get('http://www.dice.com')

form = page.form_with(:id => 'search-form')

form.q = 'developer'

form.l = 'raleigh, nc'

page = agent.submit(form)
# links = page.links_with(id: /\Aposition/)

divs = page.parser.css('div.serp-result-content')

jobtitles, companynames, postinglinks, locations, postingdates, companyids, jobids = [], [], [], [], [], [], []

posting = { jobtitle: nil, companyname: nil, location: nil, postingdate: nil,
            companyid: nil, jobid: nil }

postings = []

divs.each do |div|


end
