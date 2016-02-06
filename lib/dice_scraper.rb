# I feel like considering this scraper is specially made for the dice webpage, it should be called dice job scraper
# No need to submit a webpage, it's always going to be dice

require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'pry'
require_relative 'scraper_saver'

Job = Struct.new(:title, :company, :link, :location, :posting_date, :company_id, :job_id)

class DiceScraper

  def initialize(search_subject)
    # Instantiate a new mechanize
    @agent = Mechanize.new
    # this gives your Mechanize object
    # an 0.5 second wait time after every HTML request
    # Don't forget it!!!
    @agent.history_added = Proc.new { sleep 0.5 }
    # Grab and parse our page in one step
    # like we did with Nokogiri and open-uri
    @home_page = @agent.get('http://www.dice.com/')
    # Get our results page
    @results_page = get_results_page(search_subject)
    @saver = ScraperSaver.new
  end

  def get_results_page(search_subject)
    # Grab the form by ID or action
    form_by_action = @home_page.form_with(:action => "/jobs")
    # Fill in the field named "q" (Google's search query)
    form_by_action.q = search_subject
    # Actually submit the form
    @agent.submit(form_by_action)
  end

  # Struct.new(:title, :company, :link, :location, :posting_date, :company_id, :job_id)

  # The hub, it calls #get_current_job_details to get a struct for each inidividual jobs info and then sends that detail with the file name and mode to the @saver class #save_to_csv_file.
  def scrape_and_save(file_name, mode)
    # Going through each job on the results page
    @results_page.links_with(:href => /p\&q=/).each do |link|

      # Saving out file through the ScraperSaver class
      @saver.save_to_csv_file(get_current_job_details(link), file_name, mode)
    end
  end

  # Takes an individual job link and returns a struct full of that jobs details.
  def get_current_job_details(link)
    # Setting up a new Job struct
    current_job = Job.new

    # Getting the page specific to the job
    description_page = link.click

    # Getting job title from the description page
    current_job.title = get_title(description_page)

    # Getting the company name from the description page
    current_job.company = get_company_name(description_page)

    # Getting the link to more info from the link
    current_job.link = link.href

    # Getting the job location from the description page
    current_job.location = get_location(description_page)

    # Getting the posting data from description_page
    current_job.posting_date = get_posting_date(description_page)

    # Getting the company id from the descriptin page
    current_job.company_id = get_company_id(description_page)

    # Getting the job id from the link
    current_job.job_id = get_job_id(link, current_job.company_id)

    current_job
  end

  # Works
  def get_title(description_page)
    description_page.search(".jobTitle").text.strip
  end

  # Works
  def get_company_name(description_page)
    description_page.search(".employer").text.strip
  end

  # Works
  def get_location(description_page)
    description_page.search(".location").text.strip
  end

  # Works
  def get_posting_date(description_page)
    description_page.search('title').text.match(/([\d]+[-][\d]+[-][\d]+)/)[1]
  end

  def get_company_id(description_page)
    description_page.links_with(:href => /www.dice.com\/company/).each do |link2|
      return link2.href.match(/company\/([\w\d]+)/)[1]
    end
  end

  def get_job_id(link, company_id)
    link.href.match(/#{company_id}\/(.*)\?/)[1]
  end

end

# I think search subject is an option the user should definitely get an option on.
a = DiceScraper.new('ruby junior')

# Where to save and the mode are good options to have as well in case they want to have different files for different times or search results.
# More I'm willing to have in their for now but it might be one of those things that could be mandatory in the future - as in it will always be on 'a'.
a.scrape_and_save('testing3.csv', 'a')


