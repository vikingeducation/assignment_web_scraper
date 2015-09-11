class Parser
	def self.get_uri(request)
		string = request.join
		string = (string =~ /GET \/scrape/) ? 'scrape' : 'index'
	end

	def self.get_http_params(request)
		string = request.join
		matches = string.match(/GET \/\?(.+) /)
		params = {}
		matches[1].to_s.split('&').each do |param|
			key = param.split('=')[0]
			value = param.split('=')[1]
			params[key] = value
		end
		params
	end
end