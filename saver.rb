# We need CSV for this
require('csv')

# Class to save results as a CSV file

class CSVSaver
	def initialize(results)
		save(results)
	end

	def save(results)
		CSV.open('csv_file.csv', 'a') do |csv|
      # each one of these comes out in its own row.
      results.each do |result|
      	buffer = []
      	args = [:job_title, :company_name, :link, :location, :date, :company_id, :job_id]
      	args.each {|arg| buffer << result[arg] }
      	csv << buffer
      end
    end
    true
	end
end