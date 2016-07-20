require_relative 'script'

class Interface

 def run
  puts "Welcome to the Dice Scraper."
  puts "What would you like to search for?"
  query = gets.chomp
  puts "What location?"
  location = gets.chomp
  puts "Please wait while we search for your results."

  scraper = DiceScraper.new(query,location)
  arr = scraper.find_elements_and_return_links("div#search-results-experiment h3 .dice-btn-link")
  scraper.get_all_company_info(arr)
  puts "What starting date? (mm/dd/yyyy)"
  date = gets.chomp
  scraper.filter_date(date)

  maker = CSVMaker.new(scraper)
  maker.create_csv
  file_name = maker.name

  puts "We have saved your results in #{file_name}"
  end

end

i = Interface.new
i.run