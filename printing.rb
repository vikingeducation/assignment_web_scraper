class Printing
  def self.print_search( result )
    count = result.length
    puts "We found #{count} jobs that match you : "
    puts ""
    result.each do |job|
      puts "#{job.title}, in #{job.location}, it was #{job.date}. "
      puts "The company is #{job.company}"
      puts "And the link to the post is #{job.link}"
      puts ""
    end
  end
end