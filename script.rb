require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'pry'

class DiceScraper 
  attr_reader :agent, :page, :parsed_page
  
  def initialize(query, location)
    @agent = Mechanize.new
    @page = agent.get('http://www.dice.com/')
    @query = query
    @location = location
    build
  end
  
  def build
    form = set_up_page(@page)
    set_up_form(form, @query, @location)
    first_page = submit_form(form)
    @parsed_page = parse_page(first_page)
  end

  def set_up_page(page)
    job_form = page.form_with(:action => "/jobs")
    #input fields
  end

  def set_up_form(form,query,location)
    form.q = query
    form.l = location
  end

  def submit_form(form)
    #returns first page of search results
    @agent.submit(form,form.buttons.first)
  end

  def parse_page(page)
    @agent.page.parser
  end
  
  def find_element_count(element)
    @parsed_page.css(element).count
  end

  def find_elements_and_return_links(element)
    links = []
    elements = @parsed_page.css(element)
    elements.each do |element|
      links << element.attributes["href"].value
    end
    links
  end

  def get_elements(page, element)
    elements = page.css(element)
  end

  #inputs a link and outputs company_arr
  def get_company_info(link)
    company_page =  parse_page(@agent.get(link))

    noko_job = get_elements(company_page, ".jobTitle").children.to_s
    noko_company = get_elements(company_page, ".employer .dice-btn-link").children.to_s
    noko_location = get_elements(company_page, ".list-inline .location").children.to_s
    noko_date = get_elements(company_page, ".posted").children.to_s

    noko_company_id = get_elements(company_page, ".company-header-info .col-md-12")

    binding.pry
    
  end
end

d = DiceScraper.new("Web Developer","Hanover, NH")

arr = d.find_elements_and_return_links("div#search-results-experiment h3 .dice-btn-link")

p d.get_company_info(arr[0])

#test to recieve array of links
#p d.find_elements_and_return_links("div#search-results-experiment h3 .dice-btn-link")


# #form
# page = d.agent.get('http://www.dice.com/')
# job_form = page.form_with(:action => "/jobs")

# #input fields
# job_form.q = "Web Developer"
# job_form.l =  "Hanover, NH"


# page = d.agent.submit(job_form, job_form.buttons.first)
# #pp page

# parsed_page = d.agent.page.parser
# all_the_divs = parsed_page.css('h3')
# puts "There are #{all_the_divs.count} h3 tags. Here they are:"
# #pp parsed_page
# all_the_divs.each do |div|
#   pp div
# end
