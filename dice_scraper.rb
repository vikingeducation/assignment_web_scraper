# require "rubygems"
# require "nokogiri"
# require "open-uri"
require "mechanize"
require "csv"
require "pry"

class DiceScraper

  def initialize

    job_postings = initialize_page

    scrape(job_postings)

  end

  def calculate_date(time)
    # Method to calculate the date from the relative time string provided

    # Split string into array
    arr = time.split(" ")

    # arr[0] is the value, convert to int
    time_value = arr[0].to_i

    # arr[1] is the period (seconds, minutes, hours, days, weeks, months, or years)
    period = arr[1]

    period_in_seconds = 0

    case period
    when period.include?("second")
      period_in_seconds = period
    when period.include?("minute")
      period_in_seconds = period * 60
    when period.include?("hour")
      period_in_seconds = period * 60 * 60
    when period.include?("day")
      period_in_seconds = period_in_secondsd * 60 * 60 * 24
    when period.include?("week")
      period_in_seconds = period * 60 * 60 * 24 * 7
    when period.include?("month")
      period_in_seconds = period * 60 * 60 * 24 * 7 * 30
    when period.include?("year")
      period_in_seconds = period * 60 * 60 * 24 * 7 * 30 * 12
    end

    # Get current time
    current_time = Time.now

    # Get difference between current time and post time
    post_time = current_time - (time_value * period_in_seconds)

    "#{post_time.day}/#{post_time.month}/#{post_time.year}"

  end

  def scrape(job_elements)

    #binding.pry
    CSV.open('job_list.csv', 'a') do |csv|

      csv << ["Title", "Company Name", "Link", "Location",
      "Post Date", "Dice ID", "Job ID"]

      job_elements.each do |job_post|

        job_details = get_job_details(job_post)

        csv << job_details

      end

    end


  end

  def initialize_page

    agent = Mechanize.new
    agent.history_added = Proc.new { sleep 0.5 }
    page = agent.get('http://www.dice.com')
    search_form = page.form(:id => "search-form")
    search_form.q = "ruby web developer"
    results = search_form.submit
    results.search("div[@class='serp-result-content']")

  end

  def get_job_details(job_element)

    job_link = job_element.at_css("h3 a").attributes["href"].value
    job_title = job_element.at_css("h3").text.strip
    company_name = job_element.at_css("li[@class = employer]").text
    job_location = job_element.at_css("li[@class = location]").text
    formatted_time = calculate_date(job_element.at_css("li[@class = posted]").text)

    #https://www.dice.com/jobs/detail/Software-Engineer-%28Ruby-web%26%2347mobile%29-%26%2345-Growth-Opportunity%21-Randstad-Technologies-Newark-CA-94560/10115700b/422149?icid=sr1-1p&q=ruby web developer&l=
    link_array = job_link.split("/") # Splits by the /
    job_company_id = link_array[6]
    post_id = link_array[7].split("?")[0]

    [ job_title, company_name, job_link, job_location,
      formatted_time, job_company_id, post_id
    ]


  end
end

scraper = DiceScraper.new


