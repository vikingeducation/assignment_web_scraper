
require 'rubygems'
require 'nokogiri'  
require 'open-uri'  # our chosen HTTP library
require 'csv' 



class Scraper

  attr_reader :page

  def initialize

    @page = grab_page

  end


  def grab_page

    Nokogiri::HTML(open("https://www.dice.com/jobs/advancedResult.html?for_all=junior+developer&for_one=rails+ruby&for_loc=San+Francisco%2C+CA&limit=50&radius=20&postedDate=15&sort=relevance&jtype=Full+Time"))  

  end

  def main

    titles = []
    companies = []
    links = []

    50.times do |i|

    titles << title_scraper(i)
    companies << company_scraper(i)
    links << link_scraper(i)

    end

  end

  def title_scraper(i)
    temp_title = ""
    temp_title =  @page.css("a#position#{i}").text
    temp_title.gsub!(/[\t\r\n]/, "")
    temp_title = temp_title[0..temp_title.length/2 - 1]
  end

  def company_scraper(i)
    temp_company = ""
    temp_company = @page.css("a#company#{i}").text
    temp_company.gsub!(/[\t\r\n]/, "")
    temp_company = temp_company[0..temp_company.length/2 - 1]
  end

  def link_scraper(i)
    temp_link = ""
    temp_link = @page.css('a#position#{i}')[0].attributes["href"].value
  end

  def location_scraper
    temp_title = []
    temp_title =  @page.css("ul.list-inline.details li.location") #.each do |ul|
    #   puts ul.children[-1].text
    # end
    puts temp_title.count
    # puts temp_title
  end

  def output_to_csv

    # CSV.open('csv_file.csv', 'a') do |csv|
    #     each one of these comes out in its own row.
    #     csv << titles
    #     csv << companies
    # end

  end

end

s = Scraper.new
s.location_scraper

