require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'pry'

require 'csv'

class DiceScraper

  DICE_ID_RGX = /detail\/.*?\/(.*?)\/(.*?)\?/

  def initialize
    @agent = Mechanize.new
    #mechanize object waits 0.5secs after every HTML request
    @agent.history_added = Proc.new { sleep 0.5 }
  end

  def scrape_n_save
    mech_obj = scraping_dice
    job_list = post_generator(mech_obj)
    data = scrape_job_post(job_list)
    save_data(data)
  end

  def scraping_dice
    page = @agent.get('http://www.dice.com')
    results_page = nil
    dice_search_page = "http://www.dice.com/jobs"
    @agent.get(dice_search_page) do |page|
      results_page = page.form_with(:name => nil) do |search|
          search.q = 'junior developer'
          search.l = 'New York, NY'
      end.submit
    end
    results_page
  end

  def post_generator(mech_obj)
    job_list = mech_obj.search("div[@class=serp-result-content]") #nokogiri obj
  end

  def scrape_job_post(job_list)
    job_arr = []
    job_list.each do |job|
      link = job.css("h3 a").attribute("href").value
      id = search_IDs(link)
      employer = job.css("li.employer").text
      title = job.css("h3 a").text.strip
      location = job.css("li.location").text
      date_posted = date_conversion(job.css("li.posted").text)
      job_arr << [id, employer, title, link, location, date_posted].flatten!
    #binding.pry
    end
    job_arr #all job posts on one page
  end

  def save_data(job_arr)
    CSV.open('output.csv', 'a') do |csv|
      job_arr.each do |job|
        csv << job
      end
    end
  end

  def search_IDs(link)
    link.match(DICE_ID_RGX).captures #returns [company_id, post_id]
  end

  def date_conversion(date_str, time_of_scraping = Time.new(2015, 7, 11, 17, 8, 2, "-04:00"))
    date_str.split(" ")
    words_to_date(time_of_scraping) unless time_of_scraping.is_a?(Time)
    date = date_str[0].to_i * words_to_date(date_str[1])
  end

  def words_to_date(word)
    case word
    when "hours"
      60*60
    when "days"
      60*60*24
    when "weeks"
      60*60*24*7
    end
  end

end
