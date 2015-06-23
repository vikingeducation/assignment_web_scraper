require 'socket'

server = TCPServer.new("0.0.0.0", 8080)
loop do
  connection = server.accept
  inputline = connection.gets

  # connection.puts "Hello World"

  file = File.readlines("hw2.html")

  connection.print "HTTP/1.1 200 OK\r\n" +
           "Content-Type: text/plain\r\n" +
           "Connection: close\r\n\r\n"

  file.each { |line| connection.puts line }

  connection.close
end