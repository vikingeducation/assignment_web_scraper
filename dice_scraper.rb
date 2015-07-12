# require "rubygems"
# require "nokogiri"
# require "open-uri"
require "mechanize"
require "csv"
require "pry"

class DiceScraper

  def initialize(year = 2015, month = 01, day = 01)

    @start_date = Time.new(year, month, day)
    @agent = Mechanize.new
    @agent.history_added = Proc.new { sleep 0.5 }
    scrape

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

    if period.include?("second")
      period_in_seconds = time_value
    elsif period.include?("minute")
      period_in_seconds = time_value * 60
    elsif period.include?("hour")
      period_in_seconds = time_value * 60 * 60
    elsif period.include?("day")
      period_in_seconds = time_value * 60 * 60 * 24
    elsif period.include?("week")
      period_in_seconds = time_value * 60 * 60 * 24 * 7
    elsif period.include?("month")
      period_in_seconds = time_value * 60 * 60 * 24 * 7 * 30
    elsif period.include?("year")
      period_in_seconds = time_value * 60 * 60 * 24 * 7 * 30 * 12
    end

    # Get current time
    current_time = Time.now

    # Get difference between current time and post time
    @post_time = current_time - period_in_seconds

    "#{@post_time.month}/#{@post_time.day}/#{@post_time.year}"

  end

  def scrape

    page_count = 1

    @post_time = Time.now

    added_jobs = []

    #binding.pry
    add_header = File.exist?('job_list.csv')
    CSV.open('job_list.csv', 'a') do |csv|

      csv << ["Title", "Company Name", "Link", "Location",
      "Post Date", "Dice ID", "Job ID"] unless add_header

      until @start_date > @post_time

        job_postings = initialize_page(generate_url(page_count))

        job_postings.each do |job_post|

          job_details = get_job_details(job_post)

          unless added_jobs.include?(job_details[-1])

            csv << job_details if @post_time > @start_date

            added_jobs << job_details[-1]

          end

        end

        page_count += 1
        break if page_count > 50

      end

    end

  end

  def generate_url(page_num)
    "https://www.dice.com/jobs/q-ruby-sort-date-startPage-#{page_num}-limit-120-jobs.html"
  end

  def initialize_page(url)
    # page = agent.get('http://www.dice.com')
    # search_form = page.form(:id => "search-form")
    # search_form.q = "ruby web developer"
    # results = search_form.submit
    page = @agent.get(url)
    # binding.pry
    page.search("div[@class='serp-result-content']")

  end

  def initialize_indeed_page(url)
    page = @agent.get(url)
    page.search("div[@class='  row  result']")
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

  def generate_indeed_url(count_start)
    "http://www.indeed.com/jobs?q=ruby&start=#{count_start}"
  end
end

scraper = DiceScraper.new(2015, 06, 15)


