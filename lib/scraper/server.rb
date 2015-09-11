require 'socket'
require_relative 'parser.rb'
require_relative 'controller.rb'

class Server
	attr_accessor :host, :port

	def initialize(options={})
		@host = options[:host] || 'localhost'
		@port = options[:port] || 3000
		@headers = [
			"HTTP/1.1 200 OK\r\n",
			"Content-Type: text/html\r\n",
			"Connection: close\r\n\r\n"
		].join
		@server = TCPServer.new(host, port)
	end

	def start
		puts "Listening at http://#{host}:#{port}"
		puts "Crtl-C to quit"
		serve		
	end

	def stop
		raise Interrupt
	end

	private
		def serve
			begin
				loop do
					client = @server.accept
					request = client.recvfrom(2**16)
					print "\n#{request}\n"
					action = Parser.get_uri(request)
					response = Controller.new.send(action.to_sym)
					client.print(@headers)
					client.print(response)
					client.close
				end
			rescue SystemExit, Interrupt
				puts "Goodbye!"
			end
		end
end

if __FILE__ == $0
	Server.new.start
end