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


  private


  def to_csv(results)
    time = Time.now.strftime("%Y_%m_%d")
    CSV::open("jobs_#{time}.csv", "w+") do |csv|
      csv << ["Title", "Link", "Description"]
      results.each do |result|
        csv << [result[:title], result[:link], result[:desc]]
      end
    end
  end

end


