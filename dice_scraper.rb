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

#jobids = [], [], [], [], [], [], []

#posting = { jobtitle: nil, companyname: nil, location: nil, postingdate: nil,
#            companyid: nil, jobid: nil }


postings = divs.map do |div|
  {
  jobtitle: div.css("a[id]").select{ |a| a['id'] =~ /\Aposition/}[0].attributes[1].value,
  companyname: div.css("a[id]").select{ |a| a['id'] =~ /\Acompany/}[0].children[0].value
  #hash[:companyname] = div.parse.css("a[id]").select( |a| a[id] =~ /\Acompany/)
  }
end

pp postings[0]
