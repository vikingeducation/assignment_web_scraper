# all 3 of these requires are necessary
require 'rubygems'
require 'bundler/setup'
require 'mechanize'

class PageFormatter

	def self.get_page_from(url)
		agent = Mechanize.new { |agent| 
    		agent.user_agent_alias = 'Windows Chrome'
    		agent.history_added = Proc.new { sleep 0.5 }
		}
		page = agent.get(url)
	end
end
