require 'csv'

class JobWriter

  def save_results(filepath, results)

    headers = !File.exist?(filepath)

    CSV.open(filepath, 'a') do |csv|
      # each one of these comes out in its own row.
      csv << ["Job Title", "Company", "Link", "Location", "Posting Date", "Company ID", "Job ID"] if headers

      results.each do |job|
        csv << job.to_a
      end
    end
  end

end
