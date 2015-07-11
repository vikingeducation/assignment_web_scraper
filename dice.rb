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

#  struct job-title, company name, 
# link to posting on dice, 
# location, posting date, comp ID, Job ID

#make array of structs
#make sleeper function
# struct job-title, company name,
# link to posting on dice,
# location, posting date, comp ID, Job ID

#make array of structs
#make sleeper function
require 'nokogiri'
require 'open-uri'
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
	  page.links.each do |link|
	    puts link.text
	  end
	end
end

# def dice
# 	b = Mechanize.new

# 	b.history_added = Proc.new { sleep 0.5 }

# 	b.get("http://www.dice.com/") do |page|
# 		jobs = []
# 		#submit the search fields and get result
# 		submit_query = page.form(:id => 'search-form')
# 		submit_query.q = "Ruby on Rails"
# 		submit_query.l = "San Francisco, CA"
# 		result = b.submit(submit_query, submit_query.button)
# 		result.links_with(:href => /(?<=www.dice.com\/company\/).*/).each_with_index do |link, index|
# 			pp link.text
# 		end
# 	end
# end

# def dice
# 	b = Mechanize.new

# 	b.history_added = Proc.new { sleep 0.5 }

# 	# b.get("http://www.dice.com/") do |page|
# 	# 	jobs = []
# 		#submit the search fields and get result
# 		# submit_query = page.form(:id => 'search-form')
# 		# submit_query.q = "Ruby on Rails"
# 		# submit_query.l = "San Francisco, CA"
# 		# result = b.submit(submit_query, submit_query.button)

# 		puts result.class
# 		pp result
# 		result
# 		# process_search_results(result)
# 		# result.links_with(:href => /(?<=www.dice.com\/company\/).*/).each_with_index do |link, index|
# 		# 	pp link.text
# 		# end
# 	end
# end

def dice()
	
	b = Mechanize.new
	b.history_added = Proc.new { sleep 0.5 }

	result  = submit_search(get_page(b))
	# process_search_results(result)
end

def get_page(b)
	[b.get("http://www.dice.com/"), b]
end

def submit_search(page)

	submit_query = page[0].form(:id => 'search-form')
	submit_query.q = "Ruby on Rails"
	submit_query.l = "San Francisco, CA"
	result = page[1].submit(submit_query, submit_query.button)
	result

end

def process_search_results(results)
	# results.each(:div => "serp-result-content").each do |line|
	# 	pp line
	rows = results.search("div.serp-result-content")
	# rows = results.div('serp-result-content')
	rows.each {|row| pp row}
end

def title

end

def co_name

end

def post_link

end

def location

end

def post_date

end

def company_id

end

def job_id

end