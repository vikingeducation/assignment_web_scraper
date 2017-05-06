require 'rubygems'
require 'mechanize'
require 'bundler/setup'
require 'pry'
require 'csv'
#sets up empty job data structure
Job = Struct.new(:title, :location, :description)
#initializes new Mechanize instance
agent = Mechanize.new
#set delay
agent.history_added = Proc.new { sleep 0.5 }
job_array = []
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
	raw_links = results_page.search('.serp-result-content')
	#iterates through job titles and extracts text
	#binding.pry
	raw_links.each do |result|
		#gets description
		description = result.search('.shortdesc').text.strip
		#gets title
		title = result.search('h3 a').text.strip
		#get location
		location = result.search('.location').text
		#puts job title into node
		job_node = Job.new(title, location, description)
		#iterates through node and prints data
		job_node.each do |node|
			job_array << node
			#puts
			#puts "title: #{job_node.title},\n :location: #{job_node.location},\n description: #{job_node.description}\n"
			
		end
	end
	CSV.open("jobs.csv", "w") do |csv|
		job_array.each do |job|
			csv << [job]
		end
  end
end


pp job_array


