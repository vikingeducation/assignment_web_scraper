require 'rubygems'
require 'bundler/setup'
require 'mechanize'

class Search

  attr_reader :agent

  def get_input
    puts "What are you looking for?\nYou can search for job title, skills, keywords, or company name."
    search = gets.chomp
    puts "Zip, City, or State"
    location = gets.chomp
    puts "You are looking for #{search} in #{location}.\n"
    create_search_url(search, location)
  end

  def create_search_url(search, location)
    url = "https://dice.com/jobs?q=#{search}&l=#{location}"
    get_results(url)
  end

  def get_results(url)
    agent = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
    results = agent.get(url)
    pp results
  end

end
