require 'mechanize'
require 'csv'
require 'pry'

class Scraper

  def initialize
    @agent = Mechanize.new
    @agent.history_added = Proc.new { sleep 0.9 }
    @info_array = []
    @url = ""
    @page_num = 1
  end

  def search_dice(query, location, duration=1000)
    @duration = duration
    @url = formatted_url(query, location)
    parse_page(nav_url)
    append_to_file
  end


  def formatted_url(query, location)
    query = query.gsub(" ", "+").gsub(",", "%2C")
    location = location.gsub(" ", "+").gsub(",", "%2C")
    return "https://www.dice.com/jobs/q-#{query}-l-#{location}-radius-30-sort-date-limit-120"
  end

  def nav_url
    return @url + "-startPage-#{@page_num}-jobs"
  end

  def parse_page(url)
    page = @agent.get(url)
    listings = page.search(".serp-result-content")

    inside_duration = true
    @page_num = 1
    while (page.search(".serp-result-content").search('.dice-btn-link').any? && inside_duration)
      listings.each do |listing|

        info = {}
        info[:title] = listing.search('.dice-btn-link')[0].inner_text.strip
        info[:link] = listing.search('.dice-btn-link')[0]["href"]
        info[:jid] = get_jid(info[:link])
        info[:cname] = listing.search('.dice-btn-link')[1].inner_text.strip
        info[:cid] = get_cid(listing.search('.dice-btn-link')[1]["href"])
        info[:loc] = listing.search('.location')[0].inner_text.strip
        info[:date] = get_post_date(listing.search('.posted')[0].inner_text.strip)
        if (DateTime.now - @duration) > info[:date]
          inside_duration = false
          break
        end
        @info_array << info
      end
      @page_num += 1
      p "Getting url #{nav_url}"
      page = @agent.get(nav_url)
      listings = page.search(".serp-result-content")
    end
  end

  def print_values(symbol)
    @info_array.each do |entry|
      p entry[symbol.to_sym]
    end
  end

  def get_cid(url)
    url.split("/")[-1]
  end

  def get_jid(url)
    url.match(/\/([\w\d-]*)[?]/)[1]
  end

  def get_post_date(relative_time_str)
    offsets = {"day" => 1, "days" => 1,
               "week" => 7, "weeks" => 7,
               "month" => 30, "months" => 30,
               "year" => 365, "years" => 365}
    relative_time_str = relative_time_str.split(" ")
    multiplier = relative_time_str[0].to_i
    duration = offsets[relative_time_str[1].downcase]
    duration = 0 if duration.nil?

    return (DateTime.now - (multiplier * duration)).to_datetime
  end

  def append_to_file
    CSV.open("results.csv", "a") do |file|
      @info_array.each do |entry|
        file << [entry[:title], 
                 entry[:cname],
                 entry[:link], 
                 entry[:loc],
                 entry[:date].strftime("%B %d, %Y"),
                 entry[:cid],
                 entry[:jid]]
      end
    end
  end
end

s = Scraper.new
s.search_dice('cobol', 'ca')

# page = agent.get('https://www.dice.com/jobs?q=ruby&l=60565')

# job_listings = page.search('.serp-result-content')

#   info_array = []
#   job_listings.each do |listing|
#     info = {}
#     info[:title] = listing.search('.dice-btn-link')[0].inner_text.strip
#     info[:link] = listing.search('.dice-btn-link')[0]["href"]
#     info_array << info
#   end

# # info = get_info_from_listings(job_listings)

# info_array.each do |val|
#   p val[:link]
# end