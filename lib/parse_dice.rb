require 'mechanize'
require_relative 'web_scraper'

class ParseDice < WebScraper

  def initialize(term, location = nil)
    @agent = Mechanize.new
    @term = term
    @location = "-#{location}-30" if location
  end

  def build_url
    "https://www.dice.com/jobs/q-#{@term}-jtype-Full\%20Time-limit-30#{@location}-jobs.html"
  end

  def organize(results)
    jobs = []
    results = results.search("div.serp-result-content")
    results.each do |result|
      h3 = result.search("h3")[0]
      title = h3.text.strip
      link = h3.search("a")[0]["href"]
      short_desc = result.search("div.shortdesc")[0].text.strip
      jobs << {title: title, link: link, desc: short_desc}
    end
    jobs
  end



end

dice = ParseDice.new( 'Developer', '33613' )
puts dice.search