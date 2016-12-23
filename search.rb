Job = Struct.new(:title, :company, :link, :location, :date, :company_id, :job_id)

class Scraper 

  def initialize
    @scraper
    @page
  end

  def make_scraper
    scraper = Mechanize.new do |scraper|
      scraper.history_added = Proc.new { sleep 0.5 }
      scraper_alias = 'Windows Chrome'
    end
  end

  #maybe edit this later to perform customized search query
  def get_results
    url = "https://www.dice.com/jobs?q=rails&l=Washington%2C+DC&searchid=7137101740189"
    @page = scraper.get(url)
  end

  def collect_results
    postings = []
    @page.links_with(:class => "dice-btn-link loggedInVisited").each do |link|
      postings << scrape_info(link)
    end
  end

  # make new job object out of info on description page
  def scrape_info(link)
    binding.pry
    description = link.click
    title = description.search("h1.jobTitle").text.strip
    company = description.search("li.employer").text.strip
    location = description.search("li.location").text
    title = description.search("title").text
    date = title.match(/\d+-\d+-\d+/).to_s

    company_id = description.at("div.company-header-info").css("div").text.match(/Dice Id : (.+)/).captures.first
    job_id = description.at("div.company-header-info").css("div").text.match(/Position Id : (.+)/).captures.first
    Job.new(title, company, link, location, date, company_id, job_id)
  end




#performs search query

#returns first results page


end