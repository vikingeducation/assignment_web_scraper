require 'mechanize'
require 'csv'

class Scraper

  attr_reader  :attributes_array, :scraper, :page, :job_search, :keyword, :location, :links, :link_array

  def initialize(keyword, location)
    @scraper = Mechanize.new
    @keyword = keyword
    @location = location
    @num_results = 30
    get_page('http://www.dice.com')

  end


  def link_through
    @attributes_array = []
    @link_array.each do |link|
      attribute_array = []
      attribute_array << link.attribute("href").text
      job_page = @scraper.click(link) 
      attribute_array << job_page.search("#jt").text
      attribute_array << job_page.search('[class="employer"]').text.strip
      attribute_array << job_page.search('[class="location"]').text
      attribute_array << job_page.search('[class="posted hidden-xs"]').text
      attribute_array << job_page.search('[text()*="Dice Id"]').text
      attribute_array << job_page.search('[text()*="Position Id"]').text
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
      @link_array << @page.search("#position#{counter}")
      counter += 1
    end
    @link_array.flatten!
  end

  def sort_job(array)
    new_array = []
    array[1..2].each {|item| new_array << item}
    new_array << array[0]
    array[3..6].each {|item| new_array << item}
    new_array
  end

  def save_to_csv
    CSV.open('csv_file.csv', 'a') do |csv|
      csv << ['Job Title', 'Company Name', 'Link', 'Location', 'Posting Date', 'Company ID', 'Job ID']
      @attributes_array.each do |job|
        csv << sort_job(job)
      end
    end
  end



  
end
