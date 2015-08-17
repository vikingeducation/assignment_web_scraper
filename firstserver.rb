require 'socket'

server = TCPServer.new("0.0.0.0", 8080)
loop do
    connection = server.accept   # Open connection
    inputline = connection.gets  # Read from connection
    file = File.open('test.html', "r")
    content = file.read
    file.close
    connection.puts "HTTP/1.1 200 OK\r\n" +
           "Content-Type: text/plain\r\n" +
           "Connection: close\r\n\r\n"
    #connection.puts content
    #connection.puts "End World"# Write into connection
    connection.close             # Close connection
end