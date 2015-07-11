# require "rubygems"
# require "nokogiri"
# require "open-uri"
require "mechanize"
require "csv"

a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Chrome'
}

a.get('http://dice.com/') do |page|
  search_result = page.form_with(:id => 'search-form') do |search|
    search.q = 'Ruby developer'
  end.submit

  search_result.links.each do |link|
    # Click link
    # Get Information
    # Save to CSV
  end
end

CSV.open('job_list.csv', 'a') do |csv|

  # Get job title
  # Company name
  # Link to posting on dice
  # Location
  # Posting date
  # Company ID
  # Job ID
end


