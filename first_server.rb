require 'socket'

server = TCPServer.new("0.0.0.0", 8080)

loop do
  connection = server.accept
  connection.print "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: text/html\r\n" +
                   "Connection: close\r\n\r\n"

  connection.puts File.readlines('first_server.html') { |line| puts line }
  connection.close
end