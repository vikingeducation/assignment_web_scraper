require 'mechanize'

Movie = Struct.new(:title, :year, :summary)

found_movies = []

afi_search_page = "http://www.afi.com/members/catalog/default.aspx"

agent = Mechanize.new { |agent| 
    agent.user_agent_alias = 'Windows Chrome'
}

agent.get(afi_search_page) { |page| 
    results = page.form_with(:name => 'Search') do |search|
        search.SearchText = 'Bacon'
end.submit

results.links_with(:href => /DetailView.aspx\?s=\&Movie=/).each do |link|
    current_movie = Movie.new
    current_movie.year = link.text.match(/\(\d{4}\)$/)[0].gsub(/\D/, "")
    description_page = link.click

    # Get the movie title
    description_page.search("//center//b").each do |node|
        current_movie.title = node.text.strip;
    end

    # Get movie summary if available
    description_page.search("//td//tr[contains(., 'Summary:')]/td[2]").each do |node|
        if ((node.text =~ /\w/))
            current_movie.summary = node.text.strip
        end
    end
end
}