class DiceScraperController

  def initialize
    @scraper = Scraper.new
    @parser = DiceJobsPageParser.new
  end

  def search(terms, location)
    page = scraper.get_dice_results(terms: terms, loc: location)
    job_pages = scraper.get_job_pages(page)
    jobs = parser.build_jobs(job_pages)
    jobs
  end

  private
  attr_reader :scraper, :parser
end
