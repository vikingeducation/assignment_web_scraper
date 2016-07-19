require 'rubygems'
require 'mechanize'
require 'csv'
require 'pry'



module WebScraperProject

  class WebScraper

    class << self

      def run(url)
        @agent = Mechanize.new
        results = get_results(url)
        build_results(results)
      end

      def to_csv(results)
        CSV.open('results.csv', 'a') do |csv|
          results.each do |result|
            csv << result
          end
        end
      end

      private

        def get_results(url)
          @agent.history_added = Proc.new { sleep 0.5 }
          page = scraper.get(url)
          page.css('div#search-results-control').css('div.serp-result-content')
        end

        def build_results(results)
          results.map do |outter_div|
            title = get_title(outter_div)
            desc = get_details(outter_div)
            details = get_details(outter_div.css('ul'))
            employer = details[0]
            location = details[1]
            url = get_url(outter_div)
            [title,employer,location,desc,url]
            # date posted
            # details.css('li.posted').css('span.icon-calendar-2').text.strip
          end
        end

        def get_details(result)
          job_page = doc.at('div.serp-result-content').at('h3').at('a')
          employer = @agent.click(job_page).at('li.employer').text.strip
          employer_id = @agent.click(job_page).at('div.company-header-info').at('div')
          # employer = result.css('li.employer').css('span.hidden-xs').css('a').text.strip
          location = result.css('li.location').text.strip
          # binding.pry
          [employer,location]
        end

        def get_title(result)
          result.css('h3').css('a').text.strip
        end

        def get_desc(result)
          result.css('div.shortdesc').text.strip
        end

        def get_company_id(result)
          # get_url(result).
        end

        def get_url(result)
          result.css('h3').css('a').attribute('href').text.strip
        end

    end

  end

end

results = WebScraperProject::WebScraper.run('https://www.dice.com/jobs?q=web+developer&l=San+Jose&limit=5')
WebScraperProject::WebScraper.to_csv(results)


# h3 includes a link that has the job title
# div class "shortdesc" contains a short description
# ul class "list-inline details" contains li's "employer", "location", "posted"



#
