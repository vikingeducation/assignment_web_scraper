require 'mechanize'



agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari'
agent.history_added = Proc.new { sleep 0.5 }

page = agent.get('https://www.dice.com/jobs?q=ruby&l=San+Francisco%2C+CA')

array = page.css('.serp-result-content')

array.each do |job|
  title = job.css("h3 a").first.attributes["title"].inner_text
  location = job.css(".location").first.attributes["title"].inner_text
  posted_at = job.css(".text-wrap-padding").inner_text
  company_name = job.css('.hidden-xs .dice-btn-link').inner_text

    puts
    puts "#{title}"
    puts "Location: #{location}"
    puts "Posted at: #{posted_at}"
    puts "Company: #{company_name}"
    puts "#################################################"
end
