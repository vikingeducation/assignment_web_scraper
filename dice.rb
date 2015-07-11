=begin
1. Search form parameters:
	- Job title / keywords: class: form-control input-lg id: search-field-keyword

	- Zipcode, City or State: class: form-control  id: search-field-location
	- Find Tech Jobs
2. Pagination of results
	- URL parameters
3. Filters

a. Preform a search query and returns first results

=end

# struct job-title, company name,
# link to posting on dice,
# location, posting date, comp ID, Job ID

#make array of structs
#make sleeper function

require 'rubygems'
require 'bundler/setup'
require 'mechanize'

JobPosting = Struct.new(:title, :co_name, :post_link,
							:location, :post_date, :co_ID, :job_ID)

def goog_searcher
	a = Mechanize.new

	a.get('http://google.com/') do |page|
	  search_result = page.form('f')
	  search_result.q = 'Hello world'
	  page = a.submit(search_result, search_result.buttons.first)
	  # end.submit
	  # pp page
	  page.links.each do |link|
	    puts link.text
	  end
	end
end

def dice
	b = Mechanize.new

	b.history_added = Proc.new { sleep 0.5 }

	b.get("http://www.dice.com/") do |page|
		#submit the search fields and get result
		submit_query = page.form(:id => 'search-form')
		submit_query.q = "Ruby on Rails"
		submit_query.l = "San Francisco, CA"
		result = b.submit(submit_query, submit_query.button)
		result.links_with(:href => /(?<=www.dice.com\/company\/).*/).each do |link|
			pp link.text
		end
	end
end