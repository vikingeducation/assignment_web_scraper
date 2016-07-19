require 'rubygems'
require 'bundler/setup'
require 'mechanize'


# agent = Mechanize.new
# page = agent.get('http://www.dice.com')


a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

a.get('http://www.dice.com') do |page|
  search_result = page.form_with(:id => "search-field-keyword") do |search|
    search.q = 'rails developer'
  end.submit