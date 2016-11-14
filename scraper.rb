
require 'rubygems'
require 'bundler/setup'
require 'mechanize'

class Scraper

  def initialize(args = {})
    @agent = default_agent

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

    def default_agent
      Mechanize.new{ |agent| agent.user_agent_alias = 'Mac Safari' }
    end

    attr_reader :agent
end

page = Scraper.new.get_dice_results(terms: 'ruby', loc: 'denver co')

# how to get nokogiri methods?
# page.links_with { css: "."}

links = page.links.map do |link|
          link.text
        end

job_links = page.links_with(id: /position\d*/) # call link.click

uri = page.links.map do |link|
          link.uri
        end

# pp page.body.gsub(/\t/, " ")
pp job_links[0].click.body.gsub(/\s/, "")

# return job title
# link to posting
# company name
# location
# posting date
# company id
# job id
