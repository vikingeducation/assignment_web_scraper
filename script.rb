require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require_relative 'csv_maker'

class DiceScraper 
  attr_reader :agent, :page, :parsed_page, :jobs
  
  def initialize(query, location)
    @agent = Mechanize.new
    @page = agent.get('http://www.dice.com/')
    @query = query
    @location = location
    @jobs =[]
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
    info = {}
    company_page =  parse_page(@agent.get(link))

    noko_job = get_elements(company_page, ".jobTitle").children.to_s
    noko_job = noko_job.gsub("  ", " ")
    noko_company = get_elements(company_page, ".employer .dice-btn-link").children.to_s
    noko_location = get_elements(company_page, ".list-inline .location").children.to_s

    noko_position_id = get_elements(company_page, "meta[@name=jobId]")[0].attributes["content"].value
    noko_company_id = get_elements(company_page, "meta[@name=groupId]")[0].attributes["content"].value

    all_info = get_elements(company_page, "title").children.to_s
    date = all_info.match(/\d\d-\d\d-\d\d\d\d/)[0]
    
    info[:title] = noko_job
    info[:company] = noko_company
    info[:location] = noko_location
    info[:date] = date
    info[:company_id] = noko_company_id
    info[:position_id] = noko_position_id

    info
  end

  def get_all_company_info(link_array)
    link_array.each do |link|
      @jobs << get_company_info(link)
    end
  end

end

d = DiceScraper.new("Web Developer","Hanover, NH")

arr = d.find_elements_and_return_links("div#search-results-experiment h3 .dice-btn-link")

d.get_all_company_info(arr)

maker = CSVMaker.new(d)
maker.create_csv
