
# TODO : Major change should be done to support user interactions

Job = Struct.new(:title, :company_name, :link_on_dice, :location, :posting_date, :company_id, :id)

require_relative 'page_formatter'
require_relative 'scrape_dice'
require_relative 'result_saver'
require_relative 'search_criteria'

class DiceWebScraper

	def initialize
		@all_jobs = []
	end

	def scrape
		
		#criteria = SearchCriteria.new("Web Developer", "Los Angeles, CA", 30, nil, nil, nil, 1, nil)

		dice_search_page = "https://www.dice.com/jobs/q-Web_Developer-limit-30-l-Los_Angeles%2C_CA-radius-5-jobs.html?"
		search_result = PageFormatter.get_page_from(dice_search_page)
		jobs = Nokogiri::HTML(search_result.body).css('.complete-serp-result-div')

		all_jobs = []
		jobs.each do |job|
			title = ScrapeDice.extract_title job
			company_name = ScrapeDice.extract_company_name job
			location = ScrapeDice.extract_location job
			posting_date = ScrapeDice.extract_posting_date job
			link_on_dice = ScrapeDice.extract_link job
			full_company_link = job.css('ul').children[1].children[2].children[0].attribute('href').value
			company_id = full_company_link[29..full_company_link.length-1]
			regex = /#{company_id}\/(.*)\?/
			full_job_link = job.css('ul').first.parent.children[5].children[1].attributes["href"].value
			job_id = full_job_link.match(regex)[1]
			@all_jobs << Job.new(title, company_name, link_on_dice, location, posting_date, company_id, job_id)
		end
	end

	def render
		ResultSaver.render(@all_jobs)
	end

	def save
		ResultSaver.save(@all_jobs)
	end
end

scraper = DiceWebScraper.new
scraper.scrape
scraper.render