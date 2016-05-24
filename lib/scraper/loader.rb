require 'csv'

class Loader
	def load
		file = "#{File.dirname(__FILE__)}/data/jobs.csv"
		File.file?(file) ? CSV.read(file) : []
	end
end