require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

class Scraper

  def initialize(job, location)
    @job = job
    @location = location
    @agent = Mechanize.new
    @agent.history_added = Proc.new { sleep 0.5 }
    @page = @agent.get('http://www.dice.com')
  end

  def submit_form
    form = @page.form_with(:id => 'search-form')
    form.q = 'developer'
    form.l = 'raleigh, nc'
    @page = @agent.submit(form)
  end

  def build_job_hash
    links = get_links
    links.map do |url|
      hash = {}
      @page = @agent.get(url)
      add_attributes(hash, url)
    end
  end

  def add_attributes(hash, url)
    attr_array = %w(jobtitle employer postdate url location companyid jobid)
    attr_array.each do |title|
      method = "add_#{title}".to_sym
      send(method, hash) unless title == "url"
      send(method, hash, url) if title == "url"
    end
    hash
  end

  def add_jobtitle(hash)
    if node = @page.parser.css("h1.jobTitle")
      hash[:jobtitle] = node.children.first.text
    end
  end

  def add_employer(hash)
    if node = @page.parser.css("li.employer a")
      hash[:employer] = node.children.first.text
    end
  end

  def add_postdate(hash)
    if node = @page.parser.css('ul.details').at('li:contains("Posted")')
      hash[:postdate] = convert_time(node.children.first.text)
    end
  end

  def add_url(hash, url)
    hash[:url] = url
  end

  def add_location(hash)
    if node = @page.parser.css("li.location")
      hash[:location] = node.children.first.text
    end
  end

  def add_companyid(hash)
    if node = @page.parser.css("div.col-md-12").at('div:contains("Dice")')
      hash[:companyid] = node.children.first.text
    end
  end

  def add_jobid(hash)
    if node = @page.parser.css('div.col-md-12').at('div:contains("Position Id")')
      hash[:jobid] = node.children.first.text
    end
  end

  def write_to_csv(array)
    values = array.map do |hash|
      hash.map { |k,v| v }
    end
    CSV.open('csv_file.csv', 'a') do |csv|
      values.each { |val| csv << val }
    end
  end

  def convert_time(string)
    units = {hours: 1, hour: 1, day: 24,
             days: 24, week: 168, weeks: 168}
    num = string.split[1].to_i
    unit = string.split[2].to_sym
    (Time.now - units[unit] * num).to_s
  end

  def get_links
    links = @page.parser.css("a[id]").select{ |a| a['id'] =~ /\Aposition/ }
    links = links.map { |link_ob| link_ob.attribute_nodes[3] }.compact!
    links.map { |link_atr| link_atr.value }
  end

end
# {
#   jobtitle: @page.parser.css("h1.jobTitle").children.first.text,
#   employer: @page.parser.css("li.employer a").children.first.text,
#   postdate: convert_time(@page.parser.css('ul.details').at('li:contains("Posted")').children.first.text),
#   url: url,
#   location: @page.parser.css("li.location").children.first.text,
#   companyid: @page.parser.css("div.col-md-12").at('div:contains("Dice")').children.first.text,
#   jobid: @page.parser.css('div.col-md-12').at('div:contains("Position Id")').children.first.text
# }
searcher = Scraper.new("developer", "raleigh, nc")
searcher.submit_form
searcher.write_to_csv(searcher.build_job_hash)
