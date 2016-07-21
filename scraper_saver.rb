require_relative "scraper_ui.rb"
require_relative "scraper.rb"
require 'csv'

class ScraperSaver
  def self.save(jobs, file)
    CSV.open("#{file}.csv", 'a') do |csv|
      jobs.each { |j| csv << j.to_a }
    end
  end
end

# jobs = ScraperUI.new
# # jobs.search({q: 'ruby'}, Date.new(2016, 07, 17))
# # or
# #jobs.search({q: 'ruby'}, nil)
# scraper = Scraper.new(jobs)
# jobs = scraper.job_pages
# ScraperSaver.save(jobs, "sample")
