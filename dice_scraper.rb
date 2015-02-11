require 'rubygems'
require 'bundler/setup'
require 'mechanize'

class DiceScraper

  attr_accessor :agent
  attr_reader :page, :results

  def initialize
    @agent = Mechanize.new
    @page = agent.get('http://www.dice.com')
    search_form = page.form_with(:action=> "/jobs")
    search_form.q = "Ruby on Rails"
    search_form.l = "94612"
    @results = agent.submit(search_form)
  end
end