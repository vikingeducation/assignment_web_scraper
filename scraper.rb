require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'
require 'pry'

class Scraper

  def initialize(home_page_url, sleep_time)
    @home = home_page_url
    @sleep_time = sleep_time
    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari'
  end


  def get_home_page(url)
    home_page = @agent.get(url)
  end


  def basic_search(keywords, location)
    form = get_home_page(@home).form_with(:class => 'search-form')
    form.q = keywords
    form.l = location
    results = @agent.submit(form)
  end


  def search_with_params(keywords, location, distance, time)
    results = @agent.get("http://dice.com/jobs?q =#{keywords}&l=#{location}&djtype=#{time}&radius-#{distance}-jobs")
  end


  def filtered_job_listings(keywords, location, distance, time)
    job_links = search_with_params(keywords, location, distance, time).search('.complete-serp-result-div')
    job_links.each do |r|
      job_details = job_post_details(r)
      print_job_details(job_details)
      puts
      save_job_post(job_details)
      delay(@sleep_time)
    end
  end


  def job_post_details(individual_post)
    job_post_page = @agent.click(individual_post.at('h3 a'))
    job_title = find_details('h1#jt.jobTitle', job_post_page)
    company_name = find_details('li.employer', job_post_page).chomp(",")
    location = find_details('li.location', job_post_page)
    posting_date = job_date(job_post_page)
    company_id = get_text("Dice Id", job_post_page).gsub!("Dice Id", "Company Id")
    job_id = get_text("Position Id", job_post_page).gsub!("Position Id", "Job Id")
    job_url = job_post_page.uri
    details = { :title => job_title, :co_name => company_name, :l => location, :date => posting_date, :co_id => company_id, :job_id => job_id, :url => job_url }
  end


  def find_details(css, page)
    details = page.at(css).text.strip
  end


  def job_date(job_post_page)
    posted_at = job_post_page.at('li.posted.hidden-xs').text.strip
    time_unit = posted_at.split(" ")[2]
    time_unit += "s" unless time_unit[-1] == "s"
    amount = posted_at.split(" ")[1].to_i unless posted_at.split(" ")[1] == "moments"
    change_to_seconds = { "moments" => 30,
                          "minutes" => amount * 60,
                          "hours" => amount * 3600,
                          "days" => amount * 86400,
                          "weeks" => amount * 86400 * 7,
                          "months" => amount * 86400 * 30
                        }
    time_in_seconds = change_to_seconds[time_unit]
    date_posted = Time.now - time_in_seconds
    "#{date_posted.month}/#{date_posted.day}/#{date_posted.year}"
  end


  def get_text(string, page)
    page.search("div.company-header-info div.row div.col-md-12").each do |n|
      @text_string = n.text.strip if n.text.include?(string)
    end
    @text_string
  end

  def print_job_details(options = {})
    puts "Job Title : #{options[:title]}"
    puts "Company : #{options[:co_name]}"
    puts "Location : #{options[:l]}"
    puts "Posted : #{options[:date]}"
    puts "#{options[:co_id]}"
    puts "#{options[:job_id]}"
    puts "Job URL : #{options[:url]}"
  end


  def save_job_post(options = {})
    CSV.open('jobs.csv', 'a+') do |csv|
      csv << options.values
    end
  end


  def delay(seconds)
    sleep_delay = rand(seconds)
    sleep(sleep_delay)
  end

end

n = Scraper.new('http://www.dice.com', 5)
n.filtered_job_listings("Entry Level Ruby Developer", "West Hollywood, CA", 5, "Full Time OR Part Time")
