require 'mechanize'
require 'nokogiri'

class Scraper

  attr_reader :page

  def initialize
  scraper = Mechanize.new
  scraper.history_added = Proc.new { sleep 0.5 }
  @page = scraper.get("http://www.dice.com")
  end


end