class SearchCriteria

	attr_accessor :content, :location, :distance, :segment, :title, :company, :type, :telecommute

	def initialize(content = "Web Developer", location = "Los Angeles, CA", distance = 30, segment = nil, title = nil, company = nil, type = nil, telecommute = nil)
		@content = content
		@location =  location
		@distance = distance
		@segment = segment
		@title = title
		@company = company
		@type = type
		@telecommute = telecommute
	end

end