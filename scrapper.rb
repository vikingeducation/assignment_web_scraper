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
     all_positions = []
      arr.each do |position|
        position_name = position.at_css('h3 a').text.strip
        company = position.at_css('li a').text.strip
        link = position.at_css('h3 a').attribute('href').value
        location = position.at_css('li.location').text
        date = position.at_css('li.posted').text
        company_id = position.at_css('ul li a').attribute('href').value 
        job_id = position.at_css('h3 a').attribute('href').value

         all_positions << [position_name,company,link,location, date,company_id,job_id]
          
      end
      #pass back an arr
      write_csv(all_positions)
  end

  def write_csv (jobs)
       
    CSV.open('csv_file.csv', 'a') do |row|
      jobs.each do |job|
          row << job
      end
    end
  end
end

Scrapper.new.scrap

