# TODO: Potential improvements. Right now dice has two types of links: regular and 
# highlighted links. This scraper works only on the regular links. Highlighted links
# have a url scheme of (/jobs/result) and the page, once clicked, is also much different.
# For now, I'm going to leave it working w/ just the regular links and leave this as an
# improvement.

# Require Gems
require 'rubygems'
require 'mechanize'
require 'colorize'

# Require Relatives
require_relative('saver.rb')

# Create a struct for the final results
Result = Struct.new(:job_title, :company_name, :link, :location, :date, :company_id, :job_id)

# Going to create a class for the Scrape Bot
class ScrapeBot
	def initialize
		@agent = get_agent
	end

	public

	def save(results)
		if CSVSaver.new(results) 
			puts "Save successful".green
		else
			puts "Save unsuccessful".red
		end
	end

	def search(search_term)
		page = @agent.get('http://dice.com/') do |page|
			search_results = get_search_results(page, search_term)			# Get search results page
			job_links = get_job_links(search_results) 		# Get the job links
			final = get_job_links_info(job_links)					# Scrape the info from each item in job_links
			return final
		end
	end

	private

	# Set the agent for the Mechanize instance
	def get_agent
		agent = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
	end

	# Returns the first page of all search results
	def get_search_results(page, search_term)
		search_results = page.form_with(:action => '/jobs') do |search|
			search.q = search_term
		end.submit
		search_results
	end

	# Returns the links of all job links
	def get_job_links(search_results)
		job_links = search_results.links.find_all do |l| 
			!l.href.nil? && l.href.match(/(\/jobs\/detail\/)/)
		end
		job_links
	end

	# Gets the relevant information from each job link
	def get_job_links_info(job_links)
		all_results = []
		job_links.each do |l|
			results_page = l.click
			all_results << scrape_job_info(results_page, l)
		end
		all_results
	end

	def scrape_job_info(results_page, l)
		results = Result.new
		results.link = l.href
		# Creating a hash of all of the information and their corresponding
		# CSS element to add to the struct.
		attributes_info = {:job_title => '.jobTitle', :company_name => '#companyNameLink', :location => '.location', 
												:date => '.posted'}
		attributes_info.each do |attribute, css|
			results[attribute] = results_page.parser.css(css).inner_text
		end
		# These two don't fit the schema from above so
		# have to be treated a bit differently.
		results.company_id = get_company_id(results_page)
		results.job_id = get_job_id(results_page)
		results
	end

	def get_company_id(results_page)
		id = results_page.parser.css('.company-header-info').inner_html.match(/Dice Id : (.*)</)
		return "Company ID: #{id[1]}"
	end

	def get_job_id(results_page)
		id = results_page.parser.css('.company-header-info').inner_html.match(/Position Id : (\d*)/)
		return "Job ID: #{id[1]}"
	end
end