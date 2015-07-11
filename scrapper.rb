require 'rubygems'
require 'bundler/setup'
require 'mechanize'
# this is all it takes. CSV is standard.
require 'csv' 

class Scrapper

  def initialize
    # Instantiate a new Mechanize
    @agent = Mechanize.new 
  end

  def scrap
    # Grab and parse our page in one step
    # like we did with Nokogiri and open-uri
    page = @agent.get('http://www.dice.com/')

    # Grab the form of class="f" from the page
    #search_form = page.form('search-form')

    # Grab the form by ID or action
    keyword_form = page.form_with(:id => "search-form")
    #another_form = page.form_with(:action => "/some_path")

    # Fill in the field named "q" (Google's search query)
    keyword_form.q = 'ruby developer'

    # Actually submit the form
    page = @agent.submit(keyword_form)

    write_csv (page)
    # Print out the page using the "pretty print" command
    pp page
  end

  def write_csv (page)

    CSV.open('csv_file.csv', 'a') do |csv|
    # each one of these comes out in its own row.
    
    csv << ['Harry', 'Potter', 'Wizard', '7/31/1980', 'Male', 'England']
    csv << ['Bugs', 'Bunny', 'Cartoon', '7/27/1940', 'Male', 'The Woods']
end
  end

end

Scrapper.new.scrap

