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

  def filter_date(date)
    input_month = date.match(/([0-9]{0,2})\//).captures[0]
    input_day = date.match(/\/([0-9]{0,2})\//).captures[0]
    user_value = input_month.to_i*30 + input_day.to_i 
    @jobs.each_with_index do |hash, idx|
      month = hash[:date].match(/([0-9]{0,2})-/).captures[0]
      day = hash[:date].match(/-([0-9]{0,2})-/).captures[0]
      date_value = month *30 + day
      date_value = date_value.to_i if date_value.class != Fixnum
      user_value = user_value.to_i if user_value.class != Fixnum
      if date_value > user_value
        @jobs.delete_at(idx)
      end
    end
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


  def get_job_title(page)
    noko_job = get_elements(page, ".jobTitle").children.to_s
    noko_job = noko_job.gsub("  ", " ")
  end

  def get_company(page)
    noko_company = get_elements(page, ".employer .dice-btn-link").children.to_s
  end

  def get_location(page)
    noko_location = get_elements(page, ".list-inline .location").children.to_s
  end

  def get_position_id(page)
    noko_position_id = get_elements(page, "meta[name='jobId']")[0].attributes["content"].value
  end

  def get_company_id(page)
    noko_company_id = get_elements(page, "meta[name='groupId']")[0].attributes["content"].value
  end

  def get_date(page)
    all_info = get_elements(page, "title").children.to_s
    date = all_info.match(/\d\d-\d\d-\d\d\d\d/)[0]
  end
  #inputs a link and outputs company_arr
  def get_company_info(link)
    info = {}
    company_page =  parse_page(@agent.get(link))
    info[:title] = get_job_title(company_page)
    info[:company] = get_company(company_page)
    info[:location] = get_location(company_page)
    info[:date] = get_date(company_page)
    info[:company_id] = get_company_id(company_page)
    info[:position_id] = get_position_id(company_page)
    info
  end

  def get_all_company_info(link_array)
    link_array.each do |link|
      @jobs << get_company_info(link)
    end
  end

end
