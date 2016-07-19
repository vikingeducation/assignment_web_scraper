require 'rubygems'
require 'bundler/setup'
require 'mechanize'

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
end

d = DiceScraper.new("Web Developer","Hanover, NH")
puts d.find_elements_and_return_links("div#search-results-experiment h3 .dice-btn-link")


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