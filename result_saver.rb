require 'csv' 

class ResultSaver

	def self.render(jobs)
		jobs.each do |job|
			job_id = job.id[14..job.id.length-1]
			company_id = job.company_id[10..job.company_id.length-1]
			puts "**************** Job *****************"
			puts "\tTitle      : #{job.title}"
			puts "\tCompany    : #{job.company_name}"
			puts "\tLink       : #{job.link_on_dice}"
			puts "\tLocation   : #{job.location}"
			puts "\tDate       : #{job.posting_date}"
			puts "\tCompany ID : #{company_id}"
			puts "\tJob ID     : #{job_id}"
		end
	end

	def self.save(jobs)
		csv = CSV.open('jobs.csv', 'a')
		csv << ['Title', 'Company Name', 'Link', 'Location', 'Posted Date' , 'Company ID' , 'Job ID']
		jobs.each do |job|
			job_id = job.id[14..job.id.length-1]
			company_id = job.company_id[10..job.company_id.length-1]
			job_array = [job.title, job.company_name, job.link_on_dice, job.location, job.posting_date, company_id, job_id]
    		csv << job_array
    	end
    	csv.close
	end

end