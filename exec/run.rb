require_relative '../lib/scraper'
require_relative '../lib/dice_scraper_controller'
require_relative '../lib/dice_jobs_page_parser'

controller = DiceScraperController.new
#
controller.search('ruby', 'denver co')
