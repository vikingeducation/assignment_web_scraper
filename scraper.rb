require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

class Scraper
  attr_reader :page

  def initialize

    @agent = Mechanize.new

  end

  def scrap

    # skip form, go directly to results
    @page = @agent.get("https://www.dice.com/jobs?q=&l=Roslyn%2C+NY")

    # all results contain necessary information under one class
    results = @page.search(".//div[@class='serp-results-content']")

  end

end

# test = Scraper.new
# pp test.scrap