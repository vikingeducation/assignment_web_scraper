require 'csv'

class ScraperSaver

  # Saving our info to the csv file
  # the 'a' is important
  # it turns on Append Mode so you don't overwrite
  # your own scrape file
  def save_to_csv_file(struct, filename, mode)
    CSV.open(filename, mode) do |csv|
        # each one of these comes out in its own row.
        csv << [struct.title, struct.company, struct.link, struct.location, struct.posting_date, struct.company_id, struct.job_id]
    end
  end
end

