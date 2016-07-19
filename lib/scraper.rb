require 'rubygems'
require 'mechanize'
require 'csv'
require 'pry'



module WebScraperProject

  class WebScraper

    class << self

      def run(url,ref=nil)
        @agent = Mechanize.new
        results = get_results(url)
        build_results(results,ref)
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

        def build_results(results, reference = nil)
          ans = []
          results.each do |outer_div|
            given_date = get_date(outer_div)
            # binding.pry
            if reference.nil? || (reference >= given_date)
              title = get_title(outer_div)
              details = get_details(outer_div)
              date = string_date(given_date)
              summary = get_desc(outer_div)
              url = get_url(outer_div)
              ans << ([title,url,date,summary] + details)
            end
          end
          ans
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

        def get_url(result)
          result.css('h3').css('a').attribute('href').text.strip
        end

        def get_date(result)
          date = result.css('ul').css('li.posted').text.strip
          format_date(date)
        end

        def format_date(date)
          date_arr = date.split(" ")
          num = date_arr[0].to_i
          time = date_arr[1]
          converted = convert_date(num,time)
          (Time.new - converted)
        end

        def string_date(date)
          date.strftime("%x")
        end

        def convert_date(num,time)
          case time
          when "ago"
            0
          when "hours"
            num * 60*60
          when "days"
            num * 60*60*24
          when "weeks"
            num * 60*60*24*7
          when "months"
            num * 60*60*24*31
          else
            0
          end
        end

    end

  end

end

results = WebScraperProject::WebScraper.run('https://www.dice.com/jobs?q=web+developer&l=San+Jose&limit=5',Time.new)
WebScraperProject::WebScraper.to_csv(results)


# h3 includes a link that has the job title
# div class "shortdesc" contains a short description
# ul class "list-inline details" contains li's "employer", "location", "posted"



#
