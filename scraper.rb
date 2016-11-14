
require 'rubygems'
require 'bundler/setup'
require 'mechanize'

class Scraper

  def initialize(args = {})
    @agent = Mechanize.new
  end

  # scraper.get_dice_results(terms: 'software dev ruby', location: 'city state')
  def get_dice_results(opts = {})
    #https://www.dice.com/jobs?q=Software+Developer&l=Denver%2C+CO
    # Software+Developer
    search_term = opts[:terms].gsub(/ /, '+')
    # Denver%2C+CO
    location = opts[:loc].gsub(/ /, '%2C+')
    agent.get("https://www.dice.com/jobs?q=#{ search_term }&l=#{ location }")
  end

  private
    attr_reader :agent
end

page = Scraper.new.get_dice_results(terms: 'ruby', loc: 'denver co')

p page
