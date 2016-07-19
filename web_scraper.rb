require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'


class DiceScraper 

  def initialize 
    @scraper = Mechanize.new
    @scraper.history_added = Proc.new { sleep 0.5 }
  end

  def date_parser(date)
    units = date.match(/(moment|minute|hour|day|week|month)/)[0]
    number = date.match(/\d+/)[0].to_i
    result = case units
    when "moment"
      0
    when "minute"
      number * 60
    when "hour"
      number * 3600
    when "day"
      number * 86_400
    when "week"
      number * 86_400 * 7
    when "month"
      number * 86_400 * 30
    end

    "Posted around #{Time.now - result}"
  end


  def scrape(url)  

    page = @scraper.get('https://www.dice.com/jobs/advancedResult.html?for_one=Ruby&for_all=&for_exact=&for_none=&for_jt=&for_com=&for_loc=New+York%2C+NY&sort=relevance&limit=50&radius=0')

    search_results = page.search('.serp-result-content')

    i=0
    until (i == search_results.size/2)

      pp search_results[i].css('h3').text.strip
      pp search_results[i].css("[id*='company']")[1].text
      p link = search_results[i].css('a[id*="position"]').map { |link| link['href'] }[0]
      pp search_results[i].css("li.location").text
      pp date_parser(search_results[i].css("li.posted").text)
      link = search_results[i].css('a[id*="position"]')[0]

      posting_page = @scraper.get(search_results[i].css('a[id*="position"]').map { |link| link['href'] }[0])
      pp position_id = posting_page.search('.company-header-info').css('[text()*="Position Id"]').text.strip
      pp dice_id = posting_page.search('.company-header-info').css('[text()*="Dice Id"]').text.strip
      puts
      i+=1
    end

  end

