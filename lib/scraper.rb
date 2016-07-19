require 'rubygems'
require 'mechanize'
require 'csv'



module WebScraperProject

  class WebScraper

    class << self

      def run(url)
        results = get_results(url)
        build_results(results)
      end

      def to_csv(results)
        CSV.open('results.csv', 'a') do |csv|
          mapped_results.each do |result|
            csv << result
          end
        end
      end

      private

        def get_results(url)
          scraper = Mechanize.new
          page = scraper.get(url)
          page.css('div.serp-result-content')
        end

        def build_results(results)
          mapped_results = results.map do |outter_div|
            title = get_title(outter_div)
            desc = get_details(outter_div)
            details = get_details(outter_div.css('ul'))
            employer = details[0]
            location = details[1]
            url = get_url(outter_div)
            [title,employer,location,desc,url]
            # date posted
            # str += details.css('li.posted').css('span.icon-calendar-2').text.strip
          end
        end

        def get_details(result)
          employer = result.css('li.employer').css('span.hidden-md hidden-sm hidden-lg visible-xs').css('a').text.strip
          location = result.css('li.location').text.strip
          [employer,location]
        end

        def get_title(result)
          result.css('h3').css('a').text.strip
        end

        def get_desc(result)
          desc = result.css('div.shortdesc').text.strip
        end

        def get_company_id(result)
          get_url(result).
        end

        def get_url(result)
          result.css('h3').css('a').attribute('href').text.strip
        end

    end

  end

end

results = WebScraperProject::WebScraper.run('https://www.dice.com/jobs?q=web+developer&l=San+Jose\%2C+CA')
WebScraperProject::WebScraper.to_csv(results)


# h3 includes a link that has the job title
# div class "shortdesc" contains a short description
# ul class "list-inline details" contains li's "employer", "location", "posted"



scraper.history_added = Proc.new { sleep 0.5 }
