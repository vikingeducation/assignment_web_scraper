require 'csv'

class Saving
  def self.save( result )
    File.new('csv_file.csv', 'w') unless File.exist?('csv_file.csv')

    CSV.open('csv_file.csv', 'a') do |csv|  
      result.each do |job|
        csv << [job.title, job.company, job.link, job.location, job.date]
      end
    end
  end
end