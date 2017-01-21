require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'json'
require_relative 'search_criteria'

class FinvizWebScraper
  include SearchCriteria

  def initialize
    @agent = Mechanize.new  
  end

  def search_from_file()
  end

  def market_monitor
    data = []
    screens = File.readlines('./mm/mm_screens.txt').map { |line| line.match(/\{.*?\}/).to_s }
    urls = []
    screens.each do |screen|
      urls << generate_url(JSON.parse(screen, :symbolize_names => true))
    end
    urls.each do |url|
      data << extract_total(url) 
      sleep(rand(3))
    end
    data
    File.open('./mm/Market_Monitor.txt', 'a') do |f|
      f.puts
      f << Time.now.strftime("%m/%d/%Y %H:%M ")
      data.each do |value|
        f << value + ' '
      end
    end
  end

  def extract_total(link)
    page = @agent.get(link)
    total = page.search('td.count-text').children[1].text.split(' ')[0]
  end

  def generate_url(search_criteria_hash)
    link = 'http://finviz.com/screener.ashx?v=111&f='
    search_criteria_hash.each do |key, value|
      link += "#{key.to_s}_#{value},"
    end
    link = link[0..-2] + '&ft=4'
  end
end


screener = FinvizWebScraper.new
screener.market_monitor
