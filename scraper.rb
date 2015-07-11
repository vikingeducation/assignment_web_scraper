
require 'rubygems'
# require 'nokogiri'  
# require 'open-uri'  # our chosen HTTP library

require 'mechanize'
require 'csv' 
require 'pry'
# require 'date'



class Scraper

  attr_reader :page

  def initialize

    @page = grab_page
    @results = grab_page

  end


  def grab_page

    # Nokogiri::HTML(open("https://www.dice.com/jobs/advancedResult.html?for_all=junior+developer&for_one=rails+ruby&for_loc=San+Francisco%2C+CA&limit=50&radius=20&postedDate=15&sort=relevance&jtype=Full+Time")) 

    @agent = Mechanize.new
    @page = @agent.get("https://www.dice.com/jobs/advancedResult.html?for_all=junior+developer&for_one=rails+ruby&for_loc=San+Francisco%2C+CA&limit=50&radius=20&postedDate=15&sort=relevance&jtype=Full+Time").parser

  end

  def main

    titles = []
    companies = []
    links = []
    locations = []
    company_id = []
    position_id = []

    get_jobs_number

    2.times do |i|

      titles << title_scraper(i)
      companies << company_scraper(i)
      links << link_scraper(i)
      sleep(1)
      company_id << id_scraper(i)[0]
      position_id << id_scraper(i)[1]

    end

    locations = location_scraper
    date = date_scraper

    p titles
    p companies
    # p links
    p locations
    p date
    p company_id
    p position_id

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
    temp_link = @page.css("a#position#{i}")[0].attributes["href"].value
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

  def id_scraper(i)

    temp_page = @agent.page.link_with(:id => "position#{i}").click.parser

    temp_page.css("div.company-header-info div.row").map {|text| text.text.strip}[1..2]

  end

  def get_jobs_number

     @page.at_css("div h4 span").text.to_i

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
s.main

