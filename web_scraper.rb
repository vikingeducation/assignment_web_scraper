require 'mechanize'
require 'nokogiri'

class Scraper

  attr_reader :page, :job_title, :job_location

  def initialize
    scraper = Mechanize.new
    scraper.history_added = Proc.new { sleep 0.5 }
    page = scraper.get("http://www.dice.com")
    job_title = page.form_with(:id => "search-field-keyword")
    job_location = page.form_with(:id => "search-field-location")
    search_button = page.form_with(:class => "btn btn-primary btn-lg btn-block")

    # job_title.q = "ruby"
    # job_location.q = "Boston, MA"
    # scraper.click(search_button)
  end



  


end









  # https://www.dice.com/jobs?q=ruby&l=Boston%2C+MA