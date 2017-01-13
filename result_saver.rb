require 'csv' 

class ResultSaver

	def self.render(jobs)
		jobs.each do |job|
			puts "**************** Job *****************"
			puts "\tTitle      : #{job.title}"
			puts "\tCompany    : #{job.company_name}"
			puts "\tLink       : #{job.link_on_dice}"
			puts "\tLocation   : #{job.location}"
			puts "\tDate       : #{job.posting_date}"
			puts "\tCompany ID : #{job.company_id}"
			puts "\tJob ID     : #{job.id}"
		end
	end

	def self.save(jobs)
		csv = CSV.open('jobs.csv', 'a')
		csv << ['Title', 'Company Name', 'Link', 'Location', 'Posted Date' , 'Company ID' , 'Job ID']
		jobs.each do |job|
			job_array = [job.title, job.company_name, job.link_on_dice, job.location, job.posting_date, job.company_id, job.id]
    		csv << job_array
    	end
    	csv.close
	end

end