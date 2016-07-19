require 'rubygems'
require 'bundler/setup'
require 'mechanize'

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
      @page.parser.css("h1.jobTitle").children.first.text
      @page.parser.css("li.employer a").children.first.text
      url
      p @page.parser.css("li.location").children.first.text
    end
  end

  def get_links
    links = @page.parser.css("a[id]").select{ |a| a['id'] =~ /\Aposition/ }
    links = links.map { |link_ob| link_ob.attribute_nodes[3] }.compact!
    links.map { |link_atr| link_atr.value }
  end

end

searcher = Scraper.new("developer", "raleigh, nc")
searcher.submit_form
searcher.build_job_hash
