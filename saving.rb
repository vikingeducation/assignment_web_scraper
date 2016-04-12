require 'csv'

class Saving
  def self.save( result )
    File.new('csv_file.csv', 'w') unless File.exist?('csv_file.csv')

    CSV.open('csv_file.csv', 'a') do |csv|

      (result.length-1).downto(0) do |index|

        job = result[index]

        if index == 0
          File.open('last_date.txt','w') do |f|
            f.write job.date
          end
        end

        csv << [job.title, job.company, job.link, job.location, job.date]
        puts "#{job.title} saved"
      end
      puts "#{result.length} jobs saved"
    end
  end
end