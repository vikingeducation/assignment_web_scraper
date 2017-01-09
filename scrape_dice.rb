class ScrapeDice

	def self.extract_title(job)
		job.css('h3 a').attribute('title').value
	end

	def self.extract_company_name(job)
		job.css('ul').children[1].children[2].attribute('title').value
	end

	def self.extract_location(job)
		job.css('ul').children[3].attributes['title'].value
	end

	def self.extract_link(job)
		job.css('h3 a').attribute('href').value
	end

	def self.extract_cid(job_page)
		company_header_info = Nokogiri::HTML(job_page.body).css('.company-header-info')
		if company_header_info[0].children.size == 5
			company_id = company_header_info[0].children[1].children[1].children[0].text
		else
			company_id = company_header_info[0].children[3].children[1].children[0].text
		end
	end

	def self.extract_jid(job_page)
		company_header_info = Nokogiri::HTML(job_page.body).css('.company-header-info')
		if company_header_info[0].children.size == 5
			job_id = company_header_info[0].children[3].children[1].children[0].text
		else
			job_id = company_header_info[0].children[5].children[1].children[0].text
		end
	end

	def self.extract_posting_date(job)
		cur_time = Time.now
		unit = job.css('ul').children[5].text.split[1]
		how_many = job.css('ul').children[5].text.split[0].to_i
		unit_wo_s = unit
		unit_wo_s = unit.chop unless how_many == 1
		case unit_wo_s
		when "second"
			how_many_seconds = how_many
			actual_time = cur_time - how_many
		when "minute"
			how_many_seconds = how_many * 60
			actual_time = cur_time - how_many_seconds
		when "hour"
			how_many_seconds = how_many * 60 * 60
			actual_time = cur_time - how_many_seconds
		when "day"
			how_many_seconds = how_many * 60 * 60 * 24
			actual_time = cur_time - how_many_seconds
		when "week"
			how_many_seconds = how_many * 60 * 60 * 24 * 7
			actual_time = cur_time - how_many_seconds
		when "month"
			how_many_seconds = how_many * 60.0 * 60.0 * 24.0 * 7.0 * 4.3
			actual_time = cur_time - how_many_seconds 
		when "year"
			how_many_seconds = how_many * 60 * 60 * 24 * 7 * 52
			actual_time = cur_time - how_many_seconds
		else
			actual_time = nil
			puts 'Invalid Entry'
		end
		actual_time.strftime('%a, %d %b %Y')
	end
end