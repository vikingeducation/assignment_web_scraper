require 'mechanize'
require 'pry'
require 'csv'

class WebScraper

  attr_reader :agent

  def initialize
    @agent = Mechanize.new
  end

  def organize
    raise NotImplementedError("Methods Need to be defined by subclass")
  end

  def build_url
    raise NotImplementedError("Methods Need to be defined by subclass")
  end

  def search(page = 1)
    sleep(1)
    puts build_url(page)
    results = organize(agent.get(build_url(page)))
    results << search(page + 1) if results.length > 0
  end


end


