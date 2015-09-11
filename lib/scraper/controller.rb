require_relative 'view.rb'
require_relative 'loader.rb'
require_relative 'saver.rb'
require_relative 'scraper.rb'
require_relative 'scrape_task.rb'

class Controller
	def initialize(options={})
		@params = options[:params] || {}
		@loader = Loader.new
		@saver = Saver.new
		@scraper = Scraper.new(:task => ScrapeTask.new)
		@view = View.new
	end

	def index
		data = {:csv => @loader.load}
		@view.render('index', data)
	end

	def scrape
		data = @scraper.scrape
		@saver.save(data)
		"Done!"
	end
end