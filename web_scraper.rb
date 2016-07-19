require 'mechanize'


class Scraper

  attr_reader :scraper, :page, :job_search, :keyword, :location, :links, :link_array

  def initialize(keyword, location)
    @scraper = Mechanize.new
    @keyword = keyword
    @location = location
    @num_results = 30
  end


  

  def get_page(link)
    @page = @scraper.get(link)
    fill_out_form
    submit_form
    get_job_links
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
    counter = 0
    @link_array = []
    @num_results.times do 
      @link_array << @page.css("#position#{counter}")
      counter += 1
    end
    @link_array.flatten!
  end


  def get_title
    @page.css("#jt")[0][0]

  end




  


end

s = Scraper.new("ruby", "Boston")
s.get_page('http://www.dice.com')


# s = Mechanize.new
# page = s.get("http://www.dice.com")
# job_search = page.form_with(:id => "search-form")
# job_search.q = "ruby"
# job_search.l = "Boston"
# page = s.submit(job_search)
# links = page.css('#serp a.dice-btn-link')
# s.click(links.first)
