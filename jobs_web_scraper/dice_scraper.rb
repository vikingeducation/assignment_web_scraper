require 'csv'
require 'mechanize'

Job = Struct.new(:title, :company, :direct_link, :location, :post_date, :company_id, :job_id, :source)

class DiceScraper
  attr_reader :jobs

  def initialize
    agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Mozilla'}
    agent.history_added = Proc.new { sleep 0.5 }

    search_url = "https://www.dice.com/jobs?q=Ruby+on+Rails&l=New+Orleans%2C+LA"

    # TODO:  add pagination functionality (loop over each page)
    results = agent.get(search_url).search("div.serp-result-content")
    stop = results.length / 2

    @jobs = parse_jobs(results[0...stop])
  end

  def save_results
    file = 'job_results.csv'
    CSV.open(file, 'a') do |csv|
      # each one of these comes out in its own row.
      @jobs.each do |job|
        csv << [job.title, job.company, job.direct_link, job.location, job.post_date, job.company_id, job.job_id, job.source]
      end
    end
    puts "Successfully saved to #{file}!"
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
      post_ago = node.css('li.posted').first.children.text
      post_date = get_date(post_ago)

      jobs << Job.new(title, company, link, location, post_date, company_id, job_id, :dice)
    end

    jobs
  end

  def get_date(ago_string)
    terms = ago_string.split(' ')[0..1]
    time_quantity = terms.first.to_i

    if terms.last.include? 'week'
      date = Date.today - 7 * time_quantity
    elsif terms.last.include? 'day'
      date = Date.today - time_quantity
    elsif terms.last.include?('hour') || terms.last.include?('minute')
      date = Date.today
    else
      date = nil
    end
    date
  end
end

d = DiceScraper.new
d.save_results