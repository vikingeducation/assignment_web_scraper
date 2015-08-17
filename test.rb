require 'rubygems'
require 'nokogiri'
require 'mechanize'

def scraping_dice
    #page = agent.get('http://www.dice.com')
    agent = Mechanize.new
    results_page = nil
    dice_search_page = "http://www.dice.com/jobs"
    agent.get(dice_search_page) do |page|
      results_page = page.form_with(:name => nil) do |search|
          search.q = 'junior developer'
          search.l = 'New York, NY'
      end.submit
    end
    job_list = results_page.search("div[@class=serp-result-content]")
    #time = Time.now
    pp job_list
end

scraping_dice
