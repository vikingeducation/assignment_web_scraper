require 'mechanize'


class Scraper

  attr_reader  :attributes_array, :scraper, :page, :job_search, :keyword, :location, :links, :link_array

  def initialize(keyword, location)
    @scraper = Mechanize.new
    @keyword = keyword
    @location = location
    @num_results = 30
  end


  def link_through
    @attributes_array = []
    @link_array.each do |link|
      attribute_array = []
      job_page = @scraper.click(link) 
      attribute_array << job_page.search("#jt").text
      attribute_array << job_page.search('[class="employer"]').text.strip
      attribute_array << job_page.search('[class="location"]').text
      attribute_array << job_page.search('[class="posted hidden-xs"]').text
      attribute_array << job_page.css('[text()*="Dice Id"]')[-1].children[0].to_s
      attribute_array << job_page.css('[text()*="Position Id"]')[-1].children[0].to_s
      @attributes_array << attribute_array
    end
    
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

#iterate through link array and click each.
#search for each attribute we want
#move that found attribute into an array
# return that array
#array for each job that has each of the attributes
#eventually put all arrays into a big array into csv file





  


end

# s = Scraper.new("ruby", "Boston")
# s.get_page('http://www.dice.com')


# s = Mechanize.new
# page = s.get("http://www.dice.com")
# job_search = page.form_with(:id => "search-form")
# job_search.q = "ruby"
# job_search.l = "Boston"
# page = s.submit(job_search)
# links = page.css('#serp a.dice-btn-link')
# s.click(links.first)
