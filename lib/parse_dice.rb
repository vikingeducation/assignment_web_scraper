require_relative 'web_scraper'

class ParseDice < WebScraper

  def initialize(term, location = nil)
    @agent = Mechanize.new
    @term = term
    @location = "-l-#{location}-radius-30" if location
  end

  def build_url(page)
    "https://www.dice.com/jobs/jtype-Full\%20Time-q-#{@term}#{@location}-startPage-#{page}-limit-120-jobs.html"
  end

  def organize(results)
    jobs = []
    results = results.search("div.serp-result-content")
    results.each do |result|
      h3 = result.search("h3")[0]
      title = h3.text.strip
      link = h3.search("a")[0]["href"]
      short_desc = result.search("div.shortdesc")[0].text.strip
      company = result.search("li.employer .hidden-xs a")[0]
      company_name = company.text.strip
      company_url = company["href"]
      location = result.search("li.location")[0].text.strip
      posting_date = result.search("li.posted")[0].text.strip
      posting_date = calculate_date(posting_date).strftime("%Y_%m_%d %l %p") if posting_date
      #job_id = result.search("input")[0]
      jobs << {title: title, link: link, desc: short_desc, company: company_name, company_url: company_url, location: location, date: posting_date}
    end

    jobs
  end


end

