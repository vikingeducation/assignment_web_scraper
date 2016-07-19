require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

# agent = Mechanize.new
# page = agent.get('http://www.dice.com')


a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

# a.get('http://www.dice.com') do |page|
#   search_result = page.form_with(:id => 'search-form') do |form|
#     form.q = 'rails developer'
#     form.l = 'Orange County, Ca'
#   end.submit
#
#
#  pp search_result.links_with(:text => /Full Stack/)
# end

# a.get('https://www.dice.com/jobs/advancedSearch.html') do |page|
#   search_result = page.form_with(:id => 'ajs') do |form|
#     # form.for_all = 'Full Stack'
#     form.for_jt = 'Rails developer'
#     form.for_loc = 'Orange County, CA'
#     form.field_with(:id => 'radius') = '30 miles'
#     form.radiobuttons_with(:name => 'sort')[0].check
#   end.submit

#   puts search_result.class
#  # pp search_result.dlinks.map(&:text).map(&:strip)
# end

  #search_result = page.form_with(:id => "search-field-keyword") do |search|
     #search.q = 'rails developer'
  #end.submit


a.get('https://www.dice.com/jobs?q=&l=') do |page|
   jobs_links = page.links.find_all { |l| l.attributes.parent.name == 'h3' }
   jobs_links = jobs_links[0..29]
   search_result = page.form_with(:id => "searchJob") do |form|
     form.q = "rails developer"
     form.l = "Orange County, CA"
     #form.radius = '40'
   end.submit



  job_links = search_result.links_with(:id => /position\d+/ ).map do |link|
    link.href
  end
  job_links = job_links[0..29]
  # pp job_links.length


  job_ids = []
  company_ids = []
  jobs_links[0..2].each do |link|
    job_posting = link.click
    job_posting.search('div.company-header-info div.row').each do |noko_obj|
      # search(".details").at("span:contains('title 3')").parent.text
      text = noko_obj.text
      if text.include? "Dice Id"
        company_ids << text.strip
      elsif text.include? "Position Id"
        job_ids << text.strip
      end
    end
  end

  job_titles = search_result.search('#serp h3 a').text.split(/\n\t/).map(&:strip).select{|item| !item.empty?}[0..29] # gives us job Title


  company_names = []
  search_result.search('#serp ul li span.hidden-xs a').each do |obj|
    company_names << obj.text.strip
  end
  company_names = company_names[0..29]

  locations = []
  search_result.search('#serp ul li.location').each do |location|
    locations << location.text
  end
  locations = locations[0..29]


  posting_dates = []
  search_result.search('#serp ul li.posted').each do |obj|
    posting_dates << obj.text
  end
  posting_dates = posting_dates[0..29]
  current_time = Time.now
  posting_dates = posting_dates.map do |rel_time|
   num = rel_time.match(/\d+/)[0].to_i
   if rel_time.include?("hour")
     Time.new(current_time.year, current_time.month, current_time.day, current_time.hour - num)
   elsif rel_time.include?("day")
     Time.new(current_time.year, current_time.month, current_time.day - num)
   elsif rel_time.include?("week")
     Time.new(current_time.year, current_time.month, current_time.day - (7 * num))
   end
  end



end
