require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'Nokogiri'  
# this is all it takes. CSV is standard.
require 'csv' 

class Scrapper
  attr_reader :page

  def initialize
    # Instantiate a new Mechanize
    @agent = Mechanize.new
  end

  def scrap
    # Grab and parse our page in one step
    # like we did with Nokogiri and open-uri
    @page = @agent.get('http://www.dice.com/')

    # Grab the form by ID or action
    keyword_form = page.form_with(:id => "search-form")
    #another_form = page.form_with(:action => "/some_path")

    # Fill in the field named "q" (search query)
    keyword_form.q = 'ruby developer'

    # Actually submit the form
    @page = @agent.submit(keyword_form)

    search_by_date

    # results = page.search(".//div[@class='serp-result-content']")
    #   # pp test.first.text
    # info=build_info(results)
    #     # write_csv(info)
    

  end

  def search_by_date
    p @page.search(".//a[@div='sort-by-date-link']")
    puts "testing"
  end

  def build_info(arr)
     all_positions = []
      arr.each do |position|

        position_name=position.at_css('h3 a').text.strip
        company=position.at_css('li a').text.strip
        link=position.at_css('h3 a').attribute('href').value
        location=position.at_css('li.location').text
        #receives string like 45 minutes age or 2 days ago
        date=data_calc(position.at_css('li.posted').text) 
        company_id=position.at_css('ul li a').attribute('href').value.match(/([^\/]*)$/)[0]
        job_id=position.at_css('h3 a').attribute('href').value.match(/([^\/]*)\?/)[0][0..-2]

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

def data_calc(str)
  #minute/minutes hour/hours day/days week/weeks
  
  digit=str.split(' ')[0].to_i
  order=str.split(' ')[1]

  order=order[0..-2] if order[-1] == "s"
  
  case order.downcase
    when "second"
      Time.at(Time.now.to_i-digit).strftime("%Y-%m-%d")
    when "minute"
      Time.at(Time.now.to_i-digit*60).strftime("%Y-%m-%d")
    when "hour"
      Time.at(Time.now.to_i-digit*60*60).strftime("%Y-%m-%d")
    when "day"
      Time.at(Time.now.to_i-digit*60*60*24).strftime("%Y-%m-%d")
    when "week"
      Time.at(Time.now.to_i-digit*60*60*24*7).strftime("%Y-%m-%d")
  end

end

# puts data_calc("45 minutes ago")
# puts data_calc("1 day ago")
# puts data_calc("2 weeks ago")
# puts data_calc("5 hours ago")
Scrapper.new.scrap

