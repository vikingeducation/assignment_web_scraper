
scraper = Mechanize.new

page = scraper.get('https://www.dice.com')


puts page

page.links.each do |link|
  puts link.text
end


scraper.history_added = Proc.new { sleep 0.5 }
