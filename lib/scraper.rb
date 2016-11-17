
require 'rubygems'
require 'bundler/setup'
require 'mechanize'

class Scraper

  def initialize(args = {})
    @agent = default_agent
  end

  def get_dice_results(opts = {})
    search_term = opts[:terms].gsub(/ /, '+')
    location = opts[:loc].gsub(/ /, '%2C+')
    agent.get("https://www.dice.com/jobs?q=#{ search_term }&l=#{ location }")
  end

  # Take search result page, follow job links, and return array of Job
  # detail pages
  def get_job_pages(page)
    get_dice_job_links(page).map do |link|
      link.click
    end
  end

  private
    attr_reader :agent

    def default_agent
      scraper = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
      scraper.history_added = Proc.new { sleep 0.75  }
      scraper
    end

    def get_dice_job_links(page)
      page.links_with(id: /position\d*/)
    end
end

# page = Scraper.new.get_dice_results(terms: 'ruby', loc: 'denver co')

# how to get nokogiri methods?
# page.links_with { css: "."}

# job_links = page.links_with(id: /position\d*/) # call link.click


#p job_links[0].click.uri.path#methods.sort!
#p job_links[0].click.uri.to_s
# p job_links[0].click.title
## pp page.body.gsub(/\t/, " ")
#pp job_links[0].click.uri
#pp job_links[0].click.title
#puts "-------------------------------"
#pp job_links[1].click.uri
#pp job_links[1].click.title
#puts "-------------------------------"
#pp job_links[5].click.uri
#pp job_links[5].click.title
#puts "-------------------------------"
#pp job_links[9].click.uri
#pp job_links[9].click.title

# job title         - <page object>.title
# company name      - <page object>.title # negative index split on ' - '
# link to posting   - <page object>.uri.to_s
# location          - <page object>.title # negative index split on ' - '
# posting date      - <page object>.title # negative index split on ' - '
# company id        - <page object>.uri.path # capture last 2 '/'
# job id            - <page object>.uri.path # capture last 2 '/'
