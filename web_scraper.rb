# web_scraper.rb

require 'rubygems'
require 'mechanize'

class WebScraper
  attr_reader :mech

  def initialize
    @mech = Mechanize.new
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
    jobs = ["Javascript", "Ruby", "Bartender"]
    cities = ["New+York%2C+NY", "San+Francisco%2C+CA", "Miami%2C+FL"]
    job_types = ["Full+Time", "Part+Time", "Contracts"]
    search_string = ""
    search_string << "/jobs?"
    search_string << "q=" + jobs[0]
    search_string << "&l=" + cities[0]
    search_string << "&=djtype" + job_types[0]
    search_string
  end

  def get_results
    @mech.get("https://www.dice.com#{search_query}")
  end


end

web_scraper = WebScraper.new
p web_scraper.get_results











#agent.history_added = Proc.new { sleep 3.0 }
#agent.user_agent_alias = 'Mac Safari'

#page = agent.get("https://www.dice.com#{search_query}")
#puts page
# search_form = page.form_with :name => "f"
# search_form.field_with(:name => "q").value = "Hello"

# search_results = agent.submit search_form
# puts search_results.body

