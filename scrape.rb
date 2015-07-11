require 'mechanize'

class Scraper

  def initialize
    @agent = Mechanize.new
  end

  def search_dice(query, location)
    @agent.get(formatted_url(query, location))
  end

  def formatted_url(query, location)
    "www.dice.com/jobs?q=#{query}&l=#{location}"
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