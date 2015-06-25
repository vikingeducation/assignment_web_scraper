require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'



class DiceScraper

  BASE_URL = "https://www.dice.com/jobs"


  def initialize
    @agent = Mechanize.new

    rate_limit(0.5)
  end

  # Usage: search("jobs or keywords", "Location (City, ST or ZIP)", Start Date)
  def search(query = "Web developer", location = "Boston, MA", start_date = 0)
    @start_date = start_date

    search_form = get_search_form

    search_form.q = query
    search_form.l = location

    response = @agent.submit(search_form)

    @results = scrape_jobs( sort_by_date( response ) )

    @results.each_entry do |result|
      scrape_details(result)
    end

  end


  private


  def rate_limit(lim)
    @agent.history_added = Proc.new { sleep lim }
  end


  def get_search_form
    page = @agent.get(BASE_URL)

    page.form_with(:id => 'searchJob')
  end


  def sort_by_date(results_page)
    results_page.link_with(:id => "sort-by-date-link").click #need page=?
  end


  def scrape_jobs(results_page)
    results_page.search("#search-results-control .serp-result-content")
  end


  def scrape_details(result)
    posted_text = result.at_css("li.posted").text

    post_date = calc_date(posted_text)
    return if post_date < @start_date

    job_title = result.at_css("h3 a").text.strip
    company = result.at_css("li.employer").text
    link = result.at_css("h3 a").attributes["href"].value
    location = result.at_css("li.location").text

    id_numbers = find_id_numbers(link)

    job_details = { title: job_title,
                    company: company,
                    link: link,
                    location: location,
                    date: post_date.to_s,
                    co_id: id_numbers[1],
                    job_id: id_numbers[2]
                  }

    save(job_details)

  end


  def calc_date(posted_text)

    parse_time = posted_text.match(/(\d.*?)\s(.*?)s?\s/i)

    hours_since_post = calc_hours(parse_time)

    (Time.now - hours_since_post*60*60).to_date
  end


  def calc_hours(time_since_post)

    time_in_hours = { minute: 0,
                      hour: 1,
                      day: 24,
                      week: 168,
                      month: 720
                    }

    if time_since_post.nil?
      hours = 0
    else
      hours = time_since_post[1].to_i * time_in_hours[time_since_post[2].downcase.to_sym]
    end

    hours

  end


  def find_id_numbers(url)
    url.match(/dice.com(?:\/.*?){3}\/(.*?)\/(.*?)\?/)
  end


  def save(job_details)

    CSV.open('results.csv', 'a') do |csv|

        csv <<  [ job_details[:title],
                  job_details[:company],
                  job_details[:link],
                  job_details[:location],
                  job_details[:date],
                  job_details[:co_id],
                  job_details[:job_id]
                ]
    end

  end


end