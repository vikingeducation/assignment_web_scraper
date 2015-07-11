require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'Nokogiri'  
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

    # Grab the form by ID or action
    keyword_form = page.form_with(:id => "search-form")
    #another_form = page.form_with(:action => "/some_path")

    # Fill in the field named "q" (search query)
    keyword_form.q = 'ruby developer'

    # Actually submit the form
    page = @agent.submit(keyword_form)

    

    results = page.search(".//div[@class='serp-result-content']")
      # pp test.first.text
    info=build_info(results)
        # write_csv(info)
      

  end

  def build_info(arr)
      arr.each do |position|
        position_name=position.at_css('h3 a').text.strip
        company=position.at_css('li a').text.strip
        link=position.at_css('h3 a').attribute('href').value
        location=position.at_css('li.location').text
        date=position.at_css('li.posted').text
        company_id=position.at_css('ul li a').attribute('href').value.match(/([^\/]*)$/)[0]
        job_id=position.at_css('h3 a').attribute('href').value
      end
      #pass back an arr
  end
#   def write_csv (page)

#     CSV.open('csv_file.csv', 'a') do |csv|
#     # each one of these comes out in its own row.
    
#     csv << ['Harry', 'Potter', 'Wizard', '7/31/1980', 'Male', 'England']
#     csv << ['Bugs', 'Bunny', 'Cartoon', '7/27/1940', 'Male', 'The Woods']
# end
  # end

end

Scrapper.new.scrap

