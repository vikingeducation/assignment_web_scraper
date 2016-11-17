require_relative 'scraper' 

scraper = Scraper.new("ruby developer", "philadelphia")
jobs = scraper.get_jobs

saver = CSVSaver.new(jobs)
saver.save_csv

# saver.clear_csv