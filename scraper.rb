require 'rubygems'
require 'bundler/setup'
require 'mechanize'

# agent = Mechanize.new
# page = agent.get('http://google.com/')
# pp page



url = "https://www.dice.com/jobs?q=ruby&l=San+Jose%2C+CA"

agent = Mechanize.new { |agent| 
   agent.user_agent_alias = 'Windows Chrome'
}

page = agent.get(url) 
results = page.link_with( :class => 'serp-result-content' ) 
pp results

# agent.get(url) do |page|
#   search_result = page.form_with(:class => 'serp-result-content') do |result|
#     pp result
#   end

#   # search_result.links.each do |link|
#   #   puts link.text
#   # end
# end


# { |page| 
#    results = page.at(:class => 'serp-result-content') 
# end.submit

# results.links_with(:href => /DetailView.aspx\?s=\&Movie=/).each do |link|

#    current_movie = Movie.new

#    current_movie.year = link.text.match(/\(\d{4}\)$/)[0].gsub(/\D/, "")


#    description_page = link.click

#    # Get the movie title
#    description_page.search("//center//b").each do |node|
#        current_movie.title = node.text.strip;
#    end

#    # Get movie summary if available
#    description_page.search("//td//tr[contains(., 'Summary:')]/td[2]").each do |node|
#        if ((node.text =~ /\w/))
#            current_movie.summary = node.text.strip
#        end
#    end
# end
# }