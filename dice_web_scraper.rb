
# TODO : Major change should be done to support user interactions

Job = Struct.new(:title, :company_name, :link_on_dice, :location, :posting_date, :company_id, :id)

require_relative 'page_formatter'
require_relative 'scrape_dice'
require_relative 'result_saver'
require_relative 'search_criteria'

class DiceWebScraper

	def start_scraping_dice

		#dice_search_page = "https://www.dice.com/"

		#page = PageFormatter.get_page_from(dice_search_page)

		#criteria = SearchCriteria.new("Web Developer", "Los Angeles, CA", 30, nil, nil, nil, 1, nil)

		# search_result = page.form_with(:id => 'search-form') do |search| 
		# 	keyword  = search.fields[0]
		# 	location = search.fields[1]
		# 	keyword.value  = criteria.content
		# 	location.value = criteria.location
		# end.submit

		dice_search_page = "https://www.dice.com/jobs/q-Web_Developer-limit-30-l-Los_Angeles%2C_CA-radius-5-jobs.html?"
		search_result = PageFormatter.get_page_from(dice_search_page)
		jobs = Nokogiri::HTML(search_result.body).css('.complete-serp-result-div')

		#jobs = Nokogiri::HTML(search_result.body).css('.complete-serp-result-div')
		all_jobs = []
		i = 0
		jobs.each do |job|
			title = ScrapeDice.extract_title job
			company_name = ScrapeDice.extract_company_name job
			location = ScrapeDice.extract_location job
			posting_date = ScrapeDice.extract_posting_date job
			link_on_dice = ScrapeDice.extract_link job
			job_detail_page = PageFormatter.get_page_from(ScrapeDice.extract_link(job))
			company_id = ScrapeDice.extract_cid job_detail_page
			job_id = ScrapeDice.extract_jid job_detail_page
			all_jobs << Job.new(title, company_name, link_on_dice, location, posting_date, company_id, job_id)
			puts "job #{i} created!"
			i += 1
		end

		ResultSaver.save(all_jobs)
	end
end

scraper = DiceWebScraper.new
scraper.start_scraping_dice