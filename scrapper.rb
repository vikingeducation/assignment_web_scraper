require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'Nokogiri'  
# this is all it takes. CSV is standard.
require 'csv' 

class Scrapper
  attr_reader :page

  def initialize
    @agent = Mechanize.new
  end

  def scrap 
    
    @page = @agent.get('http://www.dice.com/')
    keyword_form = page.form_with(:id => "search-form")
    keyword_form.q = 'ruby developer'

    # Actually submit the form
    @page = @agent.submit(keyword_form)

    results = page.search(".//div[@class='serp-result-content']")
    build_info(results)  
  end

  def load_page (url)

    @agent.get(url).search(".//div[@class='serp-result-content']")

  end

#start_url ="https://www.dice.com/jobs/q-ruby+developer-sort-date-l-San+Francisco%2C+CA-radius-30-startPage-1-limit-30-jobs.html"

  def search_by_date(start_url)

    #page.link_with(:text => /date/).click ??? does return us a sorted page
    # nok=sorted_page.search(".//div[@class='jobs-page-header']")

    loop do 

        j=load_page(url)
        write_csv(build_info(j))
        #regex URL increment page index << Page-2
      break if load_page(url).empty?
    end
    
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
     all_positions
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


Scrapper.new.scrap

