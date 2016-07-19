# web_scraper.rb

require 'rubygems'
require 'mechanize'

class WebScraper

  def initialize
  end

  def get_job
    job = gets.chomp
    job.split(" ").join("+")
  end

  def get_location
    location = gets.chomp
    location.split(" ").join("+")
  end

  def get_job_type
    job_type = gets.chomp
    job_type.split(" ").join("+")
  end

  def search_query
    search_string = ""
    search_string << "jobs?"
    search_string << "q=" + get_job
    search_string << "&l=" + get_location
    search_string << "&=djtype" + get_job_type
    search_string
  end


end

agent = Mechanize.new
agent.history_added = Proc.new { sleep 3.0 }
agent.user_agent_alias = 'Mac Safari'

page = agent.get("https://www.dice.com#{search_query}")
puts page
# search_form = page.form_with :name => "f"
# search_form.field_with(:name => "q").value = "Hello"

# search_results = agent.submit search_form
# puts search_results.body

