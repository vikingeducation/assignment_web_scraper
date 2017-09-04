module JobScrapper
  class Crawler
    def initialize(search_term)
      @agent = Mechanize.new
      @agent.history_added = Proc.new { sleep 0.5 }
      @search_term = search_term
    end


    def start
      @agent.get(url)
    end

    private

    def url
      "https://www.dice.com/jobs?q?q=#{@search_term}&l="
    end
  end
end
