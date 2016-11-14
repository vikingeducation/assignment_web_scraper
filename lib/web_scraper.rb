require 'mechanize'
require 'pry'
require 'csv'

class WebScraper

  attr_reader :page, :agent

  def initialize
    @agent = Mechanize.new
    @page = agent.get('http://dice.com')
  end


  def search(term, location = nil)
    sleep(1)
    form = page.form_with(:action => '/jobs')
    form.q = term
    form.l = location if location
    results = agent.submit(form)
    results = organize(results.search('.serp-result-content'))
    to_csv(results)
  end

  private

    def organize(results)
      jobs = []
      results.each do |result|
        h3 = result.search("h3")[0]
        title = h3.text.strip
        link = h3.search("a")[0]["href"]
        short_desc = result.search("div.shortdesc")[0].text.strip
        jobs << {title: title, link: link, desc: short_desc}
      end
      jobs
    end

    def to_csv(results)
      time = Time.now.strftime("%Y_%m_%d")
      CSV::open("jobs_#{time}.csv", "w+") do |csv|
        csv << ["Title", "Link", "Description"]
        results.each do |result|
          csv << [result[:title], result[:link], result[:desc]]
        end
      end
    end

end

scraper = WebScraper.new

scraper.search('developer')