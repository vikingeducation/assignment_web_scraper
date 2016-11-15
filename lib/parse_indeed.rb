require_relative 'web_scraper'

class ParseIndeed < WebScraper


  def initialize(term, location = nil)
    @agent = Mechanize.new
    @term = term
    @location = "&l=#{location}" if location
  end

  def build_url(page)
    "http://www.indeed.com/jobs?q=#{@term}#{@location}&jt=fulltime&start=#{(page-1)*10}"
  end

  def organize(results)
    next_page = results.search("span.np")[0]
    if next_page
      if next_page.text.strip == "« Previous"
        next_page = results.search("span.np")[1]
        return [] unless next_page
      end
    end
    parse_results(results.search("div.result"))
  end

  def parse_results(results)
    jobs = []
    results.each do |result|
      h2 = result.search("h2.jobtitle")[0]
      if h2
        title = h2.text.strip
        link = h2.search("a")[0]["href"]
      else
        title = result.search("a.jobtitle")[0].text.strip
        link = result.search("a.jobtitle")[0]["href"]
      end
      short_desc = result.search("span.summary")[0].text.strip
      company = result.search("span.company")[0]
      company_name = company.text.strip
      company_url = company.search("a")[0]
      company_url = company_url["href"] if company_url
      location = result.search("span.location")[0].text.strip
      posting_date = result.search("span.date")[0].text.strip
      posting_date = calculate_date(posting_date).strftime("%Y_%m_%d %l %p") if posting_date
      #job_id = result.search("input")[0]
      jobs << {title: title, link: link, desc: short_desc, company: company_name, company_url: company_url, location: location, date: posting_date}
    end
    jobs
  end

end