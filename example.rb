require_relative 'saver'
require_relative 'searcher'
require_relative 'result'
require_relative 'scraper'

scraper = Scraper.new({:for_loc => 'San Francisco, CA', :limit => 5})
