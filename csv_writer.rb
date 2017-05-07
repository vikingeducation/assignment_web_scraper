
class CsvWriter

  def create_file(results)
  # it turns on Append Mode so you don't overwrite
  # your own scrape file
    j = 0
    CSV.open('csv_file.csv', 'a') do |csv|
      results.each do | item|
        csv << item
      end
    end
  end
end