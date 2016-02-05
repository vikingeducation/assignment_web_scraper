require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'pry'
require 'csv'

Job = Struct.new(:title, :company, :link, :location, :posting_date, :company_id, :job_id)

# Instantiate a new mechanize
agent = Mechanize.new

# this gives your Mechanize object
# an 0.5 second wait time after every HTML request
# Don't forget it!!!
agent.history_added = Proc.new { sleep 0.5 }

# Grab and parse our page in one step
# like we did with Nokogiri and open-uri
page = agent.get('http://www.dice.com/')

# Grab the form by ID or action
form_by_action = page.form_with(:action => "/jobs")

# Fill in the field named "q" (Google's search query)
form_by_action.q = 'ruby junior'

# Actually submit the form
page = agent.submit(form_by_action)


page.links_with(:href => /p\&q=/).each do |link|
  # Setting up a new Job struct
  current_job = Job.new

  # Getting the link to more info
  current_job.link = link.href

  description_page = link.click

  current_job.posting_date = description_page.search('title').text.match(/([\d]+[-][\d]+[-][\d]+)/)[1]

  current_job.company = description_page.search(".employer").text.strip

  description_page.links_with(:href => /www.dice.com\/company/).each do |link2|

    current_job.company_id = link2.href.match(/company\/([\w\d]+)/)[1]

  end

  current_job.job_id = link.href.match(/#{current_job.company_id}\/(.*)\?/)[1]

  # Getting our Job title
  current_job.title = description_page.search(".jobTitle").text.strip

  # Getting our Job title
  current_job.location = description_page.search(".location").text.strip

  # the 'a' is important
  # it turns on Append Mode so you don't overwrite
  # your own scrape file
  CSV.open('csv_file.csv', 'a') do |csv|
      # each one of these comes out in its own row.
      csv << [current_job.title, current_job.company, current_job.link, current_job.location, current_job.posting_date, current_job.company_id, current_job.job_id]
  end
end

=begin
  page.links.each do |link|
    puts link.text
  end

  results.links_with(:href => /DetailView.aspx\?s=\&Movie=/).each do |link|

    # Setting up our new_movie struct
    current_movie = Movie.new

    # Setting scraping the details for the year from the link it self.
    current_movie.year = link.text.match(/\(\d{4}\)$/)[0].gsub(/\D/, "")

    # Getting the resulting page from this link.
    description_page = link.click

    # Searching for a centered node and then getting the text from that node and stripping it before storing it as the title.
    description_page.search("//center//b").each do |node|
      current_movie.title = node.text.strip;
    end

    # Also from that page, Check if in our table information, if that td has text in it, we're gonna strip it and save it as our summary.
    description_page.search("//td//tr[contains(., 'Summary:')]/td[2]").each do |node|
      if ((node.text =~ /\w/))
        current_movie.summary = node.text.strip
      end
    end

    # At the end of all of this we're going to save that struct into our found_movies array.
    found_movies << current_movie
  end
=end






