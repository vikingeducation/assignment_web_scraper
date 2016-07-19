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
      @page = @agent.get(url)
      {
        jobtitle: @page.parser.css("h1.jobTitle").children.first.text,
        employer: @page.parser.css("li.employer a").children.first.text,
        postdate: convert_time(@page.parser.css('ul.details').at('li:contains("Posted")').children.first.text),
        url: url,
        location: @page.parser.css("li.location").children.first.text,
        companyid: @page.parser.css("div.col-md-12").at('div:contains("Dice")').children.first.text,
        jobid: @page.parser.css('div.col-md-12').at('div:contains("Position Id")').children.first.text
      }
    end
  end

  def write_to_csv(array)
    values = array.map do |hash|
      hash.map { |k,v| v }
    end
    values
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

searcher = Scraper.new("developer", "raleigh, nc")
searcher.submit_form
p searcher.write_to_csv(searcher.build_job_hash)
