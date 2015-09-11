require 'date'
require 'mechanize'

class ScrapeTask
	def initialize
		@agent = Mechanize.new
		@agent.history_added = Proc.new {sleep 1}
	end

	def exec(agent=nil)
		agent = agent || @agent
		data = []
		url = 'https://www.dice.com/jobs/q-ruby-l-19044-radius-30-startPage-1-limit-1-jobs'
		page = agent.get(url)
		puts "Scraping: #{page}"
		links = page.links_with(:href => /jobs\/detail/)
		puts "Links found: #{links.length}"
		links.each_with_index do |link, i|
			print "Processing link #{i + 1} of #{links.length}\r"
			result = link.click
			job = {}
			job[:title] = result.search('.jobTitle').text
			job[:company_name] = result.search('.employer').text.strip
			job[:link] = link.href
			job[:location] = result.search('.location').text
			posted = result.search('.posted').text
			date = dice_post_time(posted)
			job[:date] = date ? date.to_s : Date.today.to_s
			ids = result.search('.company-header-info').text.scan(/(.+):(.+)/)
			ids.map do |i|
				i = i.join(':').strip
				job[:company_id] = i if i.match(/dice/i)
				job[:job_id] = i if i.match(/position/i)
			end
			data << job
		end
		puts "\nDone!"
		data
	end

	def dice_post_time(string)
		matches = string.match(/^posted (.*) ago$/i)
		return nil unless matches
		a = matches[1].split(' ')
		return nil unless a[1]
		number = a[0].to_i
		unit = a[1].downcase
		unit += 's' unless unit[-1] == 's'
		date = Date.today
		if ['days', 'months', 'years'].include?(unit)
			a = date.to_s.split('-')
			year = a[0].to_i
			month = a[1].to_i
			day = a[2].to_i
			case unit
			when 'years'
				year -= number
			when 'months'
				month -= number
			when 'days'
				day -= number
			end
			date = Date.new(year, month, day)
		end
		date
	end
end