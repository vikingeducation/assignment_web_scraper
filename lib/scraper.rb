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
          page = @agent.get(url)
          page.css('div#search-results-control').css('div.serp-result-content')
        end

        def build_results(results)
          results.map do |outter_div|
            title = get_title(outter_div)
            details = get_details(outter_div)
            summary = get_desc(outter_div)
            url = get_url(outter_div)
            [title,url,summary] + details
            # date posted
            # details.css('li.posted').css('span.icon-calendar-2').text.strip
          end
        end


        def get_details(result)
          job_page = result.at('h3').at('a')
          employer = @agent.click(job_page).at('li.employer').text.strip
          employer_id = @agent.click(job_page).at('div.company-header-info').css('div')[1].text.strip
          job_id = @agent.click(job_page).at('div.company-header-info').css('div')[2].text.strip
          location = result.css('ul').css('li.location').text.strip
          [employer,location,employer_id,job_id]
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

        def get_date(result)
          result.css('ul').css('li.posted').text.strip
        end

        def format_date(date)
          date.split(" ")
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
