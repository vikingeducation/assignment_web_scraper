require_relative '../lib/scraper'
require_relative '../lib/dice_scraper_controller'
require_relative '../lib/dice_jobs_page_parser'
require_relative '../lib/job_writer'
require_relative '../lib/dice_jobs_ui'

# ui = DiceJobsUI.new

# ui.run


### These three lines work
controller = DiceScraperController.new

jobs = controller.search(ARGV[0], ARGV[1])

JobWriter.new.save_results('test2.csv', jobs)

#
# scraper = Scraper.new
#
# page = scraper.get_dice_results(terms: 'ruby', loc: 'dallas tx')
#
# results_page = scraper.get_job_pages(page)[0]
