require_relative '../lib/scraper'
require_relative '../lib/dice_scraper_controller'
require_relative '../lib/dice_jobs_page_parser'

controller = DiceScraperController.new

controller.search('ruby', 'denver co')

scraper = Scraper.new

page = scraper.get_dice_results(terms: 'ruby', loc: 'dallas tx')

results_page = scraper.get_job_pages(page)[0]

def get_uri(page)
  uri = page.uri.to_s
  index = uri.index('?')
  uri = uri[0...index]
  uri.split('/')[-2..-1]
end

p get_uri(results_page)
