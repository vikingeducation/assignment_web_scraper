class DiceScraperController

  def initialize
    @scraper = Scraper.new

  end
  
  page = scraper.get_dice_results(terms: 'ruby', loc: 'denver co')
  job_pages = page.get_job_pages(page)

  private
  attr_reader :scraper
end
