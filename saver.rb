require 'csv'

class Saver
  def initialize(results)
    @results = results
    write_to_file
  end

  def write_to_file
    CSV.open('search_results.csv', 'a') do |csv|
      # each one of these comes out in its own row.
      csv << ['Title', 'Company', 'Link', 'Location', 'Date', 'Company ID', 'Job ID']
      @results.each do |result|
        csv << [result.title, result.company, result.link, result.location, result.date, result.companyid, result.jobid]
      end
    end
  end



end
