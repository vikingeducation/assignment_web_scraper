require 'socket'

server = TCPServer.new("0.0.0.0", 8080)
loop do
  connection = server.accept # open connection
  inputline = connection.gets # read

  # http header
  # why does this not print when it's before the html file
  connection.print "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/plain\r\n" +
                "Connection: close\r\n\r\n"

  html = File.open("test.html")
  html.readlines.each do |line|
    connection.puts line
  end
  connection.puts inputline

  connection.puts "Hello world" # write
  connection.close
end

# why do i get address in use error if I load this file twice?