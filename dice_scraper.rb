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

divs = page.parser.css("a[id]").select{ |a| a['id'] =~ /\Aposition/ } #[0].attribute_nodes[3].value


divs.map! { |div| div.attribute_nodes[3] }.compact!

links = divs.map { |div| div.value }

# links.each do |link|
#   page = link.click
# end
pp links
#jobids = [], [], [], [], [], [], []

#posting = { jobtitle: nil, companyname: nil, location: nil, postingdate: nil,
#            companyid: nil, jobid: nil }

# postings = divs.map do |div|
#   {
#   jobtitle: div.css("a[id]").select{ |a| a['id'] =~ /\Aposition/ }[0].attribute_nodes[1].value,
#   companyname: div.css("span.hidden-xs")[0].attribute_nodes[1].value,
#   location: div.css("li.location")[0].children[1].text,
#   postingdate: div.css("li.location")[0].children[1].text
#   }
# end
