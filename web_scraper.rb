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


  def scrape(url = 'https://www.dice.com/jobs/advancedResult.html?for_one=Ruby&for_all=&for_exact=&for_none=&for_jt=&for_com=&for_loc=New+York%2C+NY&sort=relevance&limit=50&radius=0')

    page = @scraper.get(url)

    search_results = page.search('.serp-result-content')

    i=0
    CSV.open("listings.csv", "a") do |csv|
      until (i == search_results.size/2)


        csv << [title(search_results[i])]
        csv << [company_name(search_results[i])]
        csv << [link(search_results[i])]
        csv << [location(search_results[i])]
        csv << [date(search_results[i])]

        posting_page = @scraper.get(search_results[i].css('a[id*="position"]').map { |link| link['href'] }[0])
        csv << [job_id(posting_page)]
        csv << [company_id(posting_page)]
        csv << [nil]
        print "listing added\n"

        i+=1

      end
    end

  end

  def title(listing)
    safe_guard { listing.css('h3').text.strip }
  end

  def company_name(listing)
    safe_guard { listing.css("[id*='company']")[1].text }
  end

  def link(listing)
    safe_guard { listing.css('a[id*="position"]').map { |link| link['href'] }[0] }
  end

  def date(listing)
    safe_guard { date_parser(listing.css("li.posted").text) }
  end

  def location(listing)
    safe_guard { listing.css("li.location").text }
  end

  def job_id(posting_page)
    safe_guard { posting_page.search('.company-header-info').css('[text()*="Position Id"]').text.strip }
  end

  def company_id(posting_page)
    safe_guard { posting_page.search('.company-header-info').css('[text()*="Dice Id"]').text.strip }
  end

  def safe_guard
    begin
      yield
    rescue
      "n/a"
    end
  end
end

scraper = DiceScraper.new
scraper.scrape#('www.google.com')
