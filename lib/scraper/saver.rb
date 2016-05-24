require 'csv'

class Saver
	def save(data)
		file = "#{File.dirname(__FILE__)}/data/jobs.csv"
		CSV.open(file, 'a+') do |csv|
			if csv.readlines.length <= 0
				a = []
				data.first.each do |key, value|
					a << "#{key}"
				end
				csv << a
			end
			data.each do |job|
				a = []
				job.each do |key, value|
					a << "#{value}"
				end
				csv << a
			end
		end
	end
end