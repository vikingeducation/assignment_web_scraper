require 'socket'
require 'erb'

begin
	host = 'localhost'
	port = 3000
	path = "#{File.dirname(__FILE__)}/index.html.erb"
	file = File.read(path)
	headers = [
		"HTTP/1.1 200 OK\r\n",
		"Content-Type: text/html\r\n",
		"Connection: close\r\n\r\n"
	].join
	puts "Listening at http://#{host}:#{port}"
	puts "Crtl-C to shutdown\n\n"
	server = TCPServer.new(host, port)
	loop do
		connection = server.accept
		input = connection.recvfrom(8000)
		puts input
		instance_variable_set(:@input, input)
		output = ERB.new(file).result(binding)
		connection.print(headers)
		connection.print(output)
		connection.close
	end
rescue SystemExit, Interrupt
	puts "\n"
	puts "Shutting down"
	puts "Goodbye!"
end
