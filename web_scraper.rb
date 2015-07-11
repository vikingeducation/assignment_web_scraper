require 'rubygems'
require 'bundler/setup'
require 'mechanize'



agent = Mechanize.new
page = agent.get('http://www.dice.com')

dice_search_page = "http://www.dice.com/jobs"

agent.get(dice_search_page) do |page|
  results = page.form_with(:name => nil) do |search|
      search.q = 'developer'
      search.l = 'New York, NY'
  end.submit

  results.links.each do |link|
    pp link.text
  end

  #pp page
end