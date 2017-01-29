require_relative 'searcher'
require_relative 'saver'

class Scraper
  attr_reader :results
  def initialize(opts={})
    unless opts.empty?
      search(opts)
      save
    end
  end

  def search(opts={})
    searcher = Searcher.new(opts)
    searcher.search(opts)
    @results = searcher.results
  end

  def save
    saver = Saver.new(@results)
  end

end
