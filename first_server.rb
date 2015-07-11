require 'socket'
#add http-party to be able to send POST requests
# IP address is 0.0.0.0 and it's on port 8080:

server = TCPServer.new("0.0.0.0", 8080)

loop do
    connection = server.accept   # Open connection
    inputline = connection.gets  # Read from connection

    file = File.open("test.html", "r").readlines

    connection.print "HTTP/1.1 200 OK\r\n" +
           "Content-Type: text/html\r\n" +
           "Connection: close\r\n\r\n"

    connection.puts file  # Write into connection
    connection.close             # Close connection
end