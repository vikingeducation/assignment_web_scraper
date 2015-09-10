require 'net/http'
require 'uri'

class Client
	attr_accessor :uri, :host, :data, :port
	
	def initialize(options={})
		@host = options[:host] || 'localhost'
		@data = options[:data] || 'foo=bar&fiz=baz'
		@port = options[:port] || 3000
		@uri = URI("http://#{@host}:#{@port}")
		@http = Net::HTTP.new(@host, @port)
		@http.read_timeout = 1
	end

	def get
		@http.get(@uri)
	end

	def post
		@http.post(@uri, @data)
	end
end