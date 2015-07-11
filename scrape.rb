require 'mechanize'

class Scraper

  def initialize
    @agent = Mechanize.new
  end

  def search_dice(query, location)
    parse_page(@agent.get(formatted_url(query, location)))  
  end

  def formatted_url(query, location)
    "www.dice.com/jobs?q=#{query}&l=#{location}"
  end

  def parse_page(page)
    listings = page.search(".serp-result-content")

    info_array = []
    listings.each do |listing|
      info = {}
      info[:title] = listing.search('.dice-btn-link')[0].inner_text.strip
      info[:link] = listing.search('.dice-btn-link')[0]["href"]
      info[:cname] = listing.search('.dice-btn-link')[1].inner_text.strip
      info[:cid] = get_cid(listing.search('.dice-btn-link')[1]["href"])
      info[:loc] = listing.search('.location')[0].inner_text.strip
      info[:date] = get_post_date(listing.search('.posted')[0].inner_text.strip)
      info_array << info
    end
  end


  def get_cid(url)
    url.split("/")[-1]
  end

  def get_post_date(relative_time_str)
    relative_time = parse_time(relative_time_str)
    time = Time.now + relative_time
  end

  def parse_time(relative_time_str)
  end

end

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