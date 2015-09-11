require 'csv'

class Loader
	def load
		file = 'data/jobs.csv'
		File.file?(file) ? CSV.read(file) : []
	end
end