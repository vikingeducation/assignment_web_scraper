require_relative 'scraper'

class DiceScraper < Scraper
  attr_reader :jobs

  def initialize
    agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Mozilla'}
    agent.history_added = Proc.new { sleep 0.5 }

    search_url = "https://www.dice.com/jobs?q=Ruby+on+Rails&l=New+Orleans%2C+LA"

    results = agent.get(search_url).search("div.serp-result-content")
    stop = results.length / 2

    @jobs = parse_jobs(results[0...stop])
  end

  private

  def parse_jobs(results)
    jobs = []

    results.each do |node|
      job_node = node.css('h3 a').first
      title = job_node['title']
      link = job_node['href']
      company_node = node.css('li.employer a').first
      company = company_node.text
      company_id = company_node['href'].match(/company\/(.*?)\z/).captures.first
      job_id = job_node['href'].match(/#{company_id}\/(.*?)\?/).captures.first
      location = node.css('li.location').first.children.text

      # TODO: change to real date
      post_date = node.css('li.posted').first.children.text

      jobs << Job.new(title, company, link, location, post_date, company_id, job_id, :dice)
    end

    jobs
  end
end

d = DiceScraper.new
puts d.jobs