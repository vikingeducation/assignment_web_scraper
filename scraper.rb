require_relative 'lib/scraper/controller.rb'
require_relative 'lib/scraper/loader.rb'
require_relative 'lib/scraper/parser.rb'
require_relative 'lib/scraper/saver.rb'
require_relative 'lib/scraper/scrape_task.rb'
require_relative 'lib/scraper/scraper.rb'
require_relative 'lib/scraper/server.rb'
require_relative 'lib/scraper/view.rb'

Server.new.start
