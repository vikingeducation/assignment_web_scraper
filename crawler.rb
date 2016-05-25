require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

class Search

  attr_accessor :results

  def initialize
    @results = []
  end

  def get_input
    puts "What are you looking for?\nYou can search for job title, skills, keywords, or company name."
    search = gets.chomp
    puts "Zip, City, or State"
    location = gets.chomp
    puts "You are looking for #{search} in #{location}.\n"
    create_search_url(search, location)
  end

  def create_search_url(search, location)
    url = "http://dice.com/jobs?q=#{search}&l=#{location}"
    get_results(url)
  end

  def get_results(url)
    agent = Mechanize.new
    results = agent.get(url).links_with(href: /^https:\/\/www.dice.com\/jobs\/detail\/.*/)
    visit_jobs(results)
  end

  def visit_jobs(jobs)
    jobs.each_with_index do |job, index|
      next if index % 2 != 0
      page = job.click
      extract_job(page)
    end
    make_csv
  end

  def extract_job(page)
    print "**"
    data = page.title.split(" - ")
    title, company, location, date = data[0], data[1], data[2], data[3][0..9]
    url = page.canonical_uri
    @results << [title, company, url, location, date]
  end

  def make_csv
    CSV.open('jobs.csv', 'a') do |csv|
      @results.each do |result|
        csv << result
      end
    end
  end

end
