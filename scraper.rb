
require 'rubygems'
# require 'nokogiri'  
# require 'open-uri'  # our chosen HTTP library

require 'mechanize'
require 'csv' 
require 'pry'
# require 'date'



class Scraper

  attr_reader :page, :links

  def initialize (initial_url)

    @page = set_page(initial_url)


  end

  def 


  def grab_page(url)

    @agent = Mechanize.new
    @page = @agent.get(url).parser

  end

  def set_page(url)
      
    (1... how many pages ) do |current|

      url.gsub("Page-#{current}","Page-#{current+1}")

   end

  end

  def main

    titles = []
    companies = []
    links = []
    locations = []
    company_id = []
    position_id = []

    get_jobs_number

    get_jobs_number.times do |i|

      titles << title_scraper(i)
      companies << company_scraper(i)
      links << link_scraper(i)
      company_id << id_scraper(links[i])[0]
      position_id << id_scraper(links[i])[1]

    end

    locations = location_scraper
    date = date_scraper

    info = [titles, companies, links, locations, date, company_id, position_id].transpose

    output_to_csv(info)

  end

  def title_scraper(i)
    temp_title =  @page.css("a#position#{i}").text
    temp_title.gsub!(/[\t\r\n]/, "")
    temp_title = temp_title[0..temp_title.length/2 - 1]
  end

  def company_scraper(i)
    temp_company = @page.css("a#company#{i}").text
    temp_company.gsub!(/[\t\r\n]/, "")
    temp_company = temp_company[0..temp_company.length/2 - 1]
  end

  def link_scraper(i)
    temp_link = @page.css("a#position#{i}")[0].attributes["href"].value
    temp_link
  end

  def location_scraper
    temp_location = []
    @page.css("ul.list-inline.details li.location").each do |ul|
      temp_location << ul.children[-1].text
    end
    temp_location[0..temp_location.length/2 - 1]
   
  end

  def date_scraper

    temp_date = []
    @page.css("ul.list-inline.details li.posted").each do |li|
      temp_date << li.text
    end
    
    temp_date[0..temp_date.length/2 - 1].map {|date| date_calculator(date)}

  end

  def date_calculator(date)

    current_date = Date.today

    if date.include?("days")
      (current_date - date.to_i).strftime("%b %-d, %y")
    elsif date.include?("weeks")
      (current_date - date.to_i * 7).strftime("%b %-d, %y")
    else
      current_date.strftime("%b %-d, %y")
    end

  end


  def id_scraper(link)
    regex = /[^\/]*\/[^\/]*\?/

    temp = link.match(regex).to_s
    temp.slice!("?")
    temp.split("/")

  end

  def get_jobs_number

     @page.css("div.serp-result-content").count/2

  end



  def output_to_csv(info)

    CSV.open('csv_file.csv', 'a') do |csv|
        info.each do |i|
          csv << i
        end
    end

  end

end

original_url = "https://www.dice.com/jobs/advancedResult.html?for_all=junior+developer&for_one=rails+ruby&for_loc=San+Francisco%2C+CA&limit=50&radius=20&postedDate=15&sort=relevance&jtype=Full+Time"

java_url = "https://www.dice.com/jobs/q-javascript+senior+developer-jtype-Full+Time-l-San+Francisco%2C+CA-radius-20-startPage-1-limit-120-jobs.html"

s = Scraper.new(java_url)
s.main


