require_relative 'mechanize_agent'

class JobLinksForLocations

  def initialize(keywords, zipcodes)
    @keywords = keywords
    @zipcodes = zipcodes
    @agent = DiceMech.new
  end


  def get_links
    links = []

    @zipcodes.each do |zipcode|
      puts "Getting results for ZIP: #{zipcode}...\n"

      # Dice search results page for first 100 results, 40 mile radius of ZIP
      search_url = "https://www.dice.com/jobs/q-" +
                   "#{@keywords.join("+")}-l-#{zipcode}" + 
                   "-radius-40-startPage-1-limit-100-jobs.html"
      page = get_search_page(search_url) 

      unless page.nil?

        page.links_with(:href => /jobs\/detail/).each do |mechlink|
          link = mechlink.uri.to_s
          # links appear twice on page, so check for duplicates
          # also maybe search results for zipcodes overlap
          links << link unless links.include?(link)
        end

      end

    end

    links

  end


  def get_search_page(url)
    begin
      @agent.get(url)
    rescue => error
      puts "Error getting search page: #{error}"
    end
  end
  
end