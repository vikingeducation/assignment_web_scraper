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


require 'rubygems'
require 'bundler/setup'
require 'mechanize'


a = Mechanize.new
a.get("http://www.dice.com/") do |page|
	#submit the search fields and get result
	search_result = page.form_with(:class => 'form-control') do |submit_query|
		submit_query.q = "Ruby on Rails"
		submit_query.l = "San Francisco, CA"
	end.submit

	search_result.length.each  do |link|
		puts link.text
	end

end