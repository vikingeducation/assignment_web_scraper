require 'mechanize'
require 'active_support/core_ext/numeric/time'

class WebScraper

  attr_reader :agent

  def initialize
    @agent = Mechanize.new
  end

  def organize
    raise NotImplementedError("Methods Need to be defined by subclass")
  end

  def build_url
    raise NotImplementedError("Methods Need to be defined by subclass")
  end

  def search(page = 1)
    sleep(1)
    puts build_url(page)
    results = organize(agent.get(build_url(page)))
    results << search(page + 1) if results.length > 0
  end

  def calculate_date(date_string)
    arr = date_string.split(" ")
    arr[0] = arr[0].to_i
    case arr[1]
    when /minute/
      arr[0].minutes.ago
    when /hour/
      arr[0].hours.ago
    when /day/
      arr[0].days.ago
    when /week/
      arr[0].weeks.ago
    when /month/
      arr[0].months.ago
    end
  end


end


