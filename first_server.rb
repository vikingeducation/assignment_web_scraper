require 'socket'

server = TCPServer.new("0.0.0.0", 8080)
file = File.readlines('file.html')

loop do
  connection = server.accept
  inputline = connection.gets

  puts inputline

  connection.print "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: text/plain\r\n" +
                   "Connection: close\r\n\r\n"

  file.each do |line|
    puts line
    connection.puts line
  end

  connection.close
  print "\n\n"
end