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

  def search
    sleep(1)
    puts build_url
    organize(agent.get(build_url))
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


