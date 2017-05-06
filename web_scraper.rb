require 'rubygems'
require 'mechanize'
require 'bundler/setup'
require 'pry'
#sets up empty job data structure
Job = Struct.new(:title, :location, :description)
#initializes new Mechanize instance
agent = Mechanize.new
#set delay
agent.history_added = Proc.new { sleep 0.5 }

URL = "https://www.dice.com"

agent.get(URL) do |search_page|
	#gets start page form
	search_form = search_page.form_with(:action => '/jobs') do |search|
		#sets input values for job form
		search['q'] = 'rails'
		search['l'] = '95112'
	end
	#submit form and puts results into variable
	results_page = search_form.submit
	#gets links for job titles
	raw_links = results_page.search('h3')
	#iterates through job titles and extracts text
	raw_links.each do |result|

		title = result.search('a').text
		#puts job title into node
		job_node = Job.new(title, nil, nil)
		#iterates through node and prints data
		job_node.each do

			pp job_node.title.strip

		end
	end

end


