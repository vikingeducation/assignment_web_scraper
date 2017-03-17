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
    if m = s.match(/hour/)
      now - (hour * m.pre_match.strip.to_i)
    elsif m = s.match(/day/)
      now - (day * m.pre_match.strip.to_i)
    elsif m = s.match(/week/)
      now - (week * m.pre_match.strip.to_i)
    end
  end

  def to_csv(path)
    CSV.open(path, "a") do |f|
      listings.each{ |row| f << row }
    end
  end

  def scrape(url)
    page = agent.get(url)
    if jobs = page.search(".complete-serp-result-div")
      @listings += jobs.each_with_index.map do |job, i|
        position = job.search("#position#{i}").first.text.strip
        company_name = job.search("#company#{i}").first.text.strip
        job_link = job.search("#position#{i}").first.attributes["href"].value.gsub(/\s/, "%20")
        description = job.search(".shortdesc").first.text.strip
        location = job.search(".location").first.text
        posted = job.search(".posted").first.text
        company_link = job.search("#company#{i}").first.attributes["href"].value
        [
          position, company_name, job_link, description, location,
          parse_date(posted), company_link
       ]
     end
   end
 end

end

if __FILE__ == $0
  s = Scraper.new
  puts "Scraping..."
  s.scrape("https://www.dice.com/jobs/q-programmer-l-San_Francisco_Bay_Area%2C_CA-radius-30-startPage-1-jobs")
  puts "#{s.listings.count} entries found"
  puts "Saving..."
  s.to_csv("listings.csv")
  puts "Done"
end
