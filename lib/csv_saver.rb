module JobScrapper
  class CSVSaver
    require 'csv'

    FILE_NAME = 'job_search_results.csv'

    def initialize(results)
      @results = results
    end

    def save
      CSV.open(FILE_NAME, 'a') do |csv|
        csv << @results.first.keys if File.zero?(FILE_NAME)

        @results.each do |result|
          csv << result.values
        end
      end
    end
  end
end
