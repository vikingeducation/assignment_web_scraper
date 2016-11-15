class DiceScraperController

  def initialize
    @scraper = Scraper.new
  end

  def search(terms, location)
    page = scraper.get_dice_results(terms: terms, loc: location)
    job_pages = scraper.get_job_pages(page)
    #p job_pages[1].title
    #p job_pages[1].uri.to_s
  end

  private
  attr_reader :scraper
end

