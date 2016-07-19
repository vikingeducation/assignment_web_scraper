require 'mechanize'


class Scraper

  attr_reader :scraper, :page, :job_search, :keyword, :location, :links

  def initialize(keyword, location)
    @scraper = Mechanize.new
    @keyword = keyword
    @location = location
  end

  def get_page(link)
    @page = @scraper.get(link)
  end

  def fill_out_form
    @job_search = @page.form_with(:id => "search-form")
    @job_search.q = @keyword
    @job_search.l = @location
  end

  def submit_form
    @page = @scraper.submit(@job_search)
  end

  def get_job_links
    @links = @page.css('#serp a.dice-btn-link')
  end




  


end

# s = Mechanize.new
# page = s.get("http://www.dice.com")
# job_search = page.form_with(:id => "search-form")
# job_search.q = "ruby"
# job_search.l = "Boston"
# page = s.submit(job_search)
# links = page.css('#serp a.dice-btn-link')
# s.click(links.first)
