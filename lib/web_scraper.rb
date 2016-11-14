require 'mechanize'
require 'pry'
require 'csv'

class WebScraper

  attr_reader :page, :agent

  def initialize
    @agent = Mechanize.new
    @page = agent.get('http://dice.com')
  end


  def search(term)
    sleep(1)
    form = page.form_with(:action => '/jobs')
    form.q = term
    results = agent.submit(form)
    organize(results.search('.serp-result-content'))
  end

  private

    def organize(results)
      jobs = []
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

scraper = WebScraper.new

scraper.search('developer')