require "rubygems"
require "mechanize"
require "csv"

$agent = Mechanize.new{ |agent| agent.user_agent_alias = "Mac Safari" }
$agent.history_added = Proc.new { sleep 0.5 }

class Scraper
  attr_accessor :agent, :listings

  def initialize
    @listings = []
    @agent = $agent
  end

  def parse_date(s)
    now = Time.now
    minute = 60
    hour = minute * 60
    day = hour * 24
    week = day * 7
    month = day * 30
    if m = s.match(/minute/)
      now - (minute * m.pre_match.strip.to_i)
    elsif m = s.match(/hour/)
      now - (hour * m.pre_match.strip.to_i)
    elsif m = s.match(/day/)
      now - (day * m.pre_match.strip.to_i)
    elsif m = s.match(/week/)
      now - (week * m.pre_match.strip.to_i)
    elsif m = s.match(/month/)
      now - (month * m.pre_match.strip.to_i)
    end
  end

  def to_csv(path)
    CSV.open(path, "a") do |f|
      listings.each{ |row| f << row }
    end
  end

  def parse_options(opts)
    query = opts[:query] || "programmer"
    location = opts[:location] || "San_Francisco_Bay_Area%2C_CA"
    radius = opts[:radius] || "30"
    startpage = opts[:startpage] || "1"
    "q-#{query}-l-#{location}-radius-#{radius}-startPage-#{startpage}-jobs"
  end

  def parse_jobs(jobs)
    jobs.map do |job, i|
      position = job.search("#position#{i}").first.text.strip
      company_name = job.search("#company#{i}").first.text.strip
      job_link = job.search("#position#{i}").first.attributes["href"].value.gsub(/\s/, "%20")
      description = job.search(".shortdesc").first.text.strip
      location = job.search(".location").first.text
      posted = job.search(".posted").first.text
      company_link = job.search("#company#{i}").first.attributes["href"].value
      [position, company_name, job_link, description, location,
       parse_date(posted), company_link]
    end
  end

  def scrape_since(date, opts = {}, acc = [])
    url = "https://www.dice.com/jobs/" + parse_options(opts)
    page = agent.get(url)
    if jobs = page.search(".complete-serp-result-div")
      jobs = jobs.each_with_index.select do |j, i|
        posted = parse_date(j.search(".posted").first.text)
        (posted.day >= date.day) && (posted.month >= date.month)
      end
      return acc if jobs.empty?
      startpage = opts[:startpage]
      opts[:startpage] = startpage.nil? ? 2 : startpage + 1
      # for safety
      return acc if opts[:startpage] >= 5
      scrape_since(date, opts, acc + parse_jobs(jobs))
    end
  end

  def scrape_first_page(opts = {})
    url = "https://www.dice.com/jobs/" + parse_options(opts)
    page = agent.get(url)
    if jobs = page.search(".complete-serp-result-div")
      @listings += parse_jobs(jobs.each_with_index)
   end
 end

end

def test_one
  s = Scraper.new
  puts "Scraping..."
  s.scrape_first_page
  puts "#{s.listings.count} entries found"
  puts "Saving..."
  s.to_csv("listings.csv")
  puts "Done"
end

def test_two
  s = Scraper.new
  puts "Scraping..."
  s.listings = s.scrape_since(Time.now)
  puts "#{s.listings.count} entries found"
  puts "Saving..."
  s.to_csv("listings.csv")
  puts "Done"
end

if __FILE__ == $0
  test_two
end
