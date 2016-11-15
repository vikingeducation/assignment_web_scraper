require_relative '../lib/scraper'
require_relative '../lib/dice_scraper_controller'
require_relative '../lib/dice_jobs_page_parser'
require_relative '../lib/job_writer'


controller = DiceScraperController.new

jobs = controller.search('ruby', 'denver co')

JobWriter.new.save_results('test.csv', jobs)

#
# scraper = Scraper.new
#
# page = scraper.get_dice_results(terms: 'ruby', loc: 'dallas tx')
#
# results_page = scraper.get_job_pages(page)[0]
