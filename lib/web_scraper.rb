require 'mechanize'
require 'pry'

class WebScraper

  attr_reader :page, :agent

  def initialize
    @agent = Mechanize.new
    @page = agent.get('http://dice.com')
  end


  def search(term)
    # binding.pry
    form = page.form_with(:action => '/jobs')
    form.q = term
    results = agent.submit(form)
    pp results
  end



end

scraper = WebScraper.new

scraper.search('developer')