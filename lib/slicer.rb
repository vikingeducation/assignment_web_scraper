module JobScrapper
  class Slicer
    def initialize(page)
      @page = page
    end

    def results
      @page.search('.serp-result-content').
        map do |result|
          {
            job_title: job_title(result),
            company_name: company_name(result),
            posting_url: posting_url(result),
            location: location(result),

          }
        end
    end

    private

    def job_title(result)
      job_link(result).text.strip
    end

    def company_name(result)
      result.at('.compName').text.strip
    end

    def posting_url(result)
      job_link(result).attribute('href').value
    end

    def location(result)
      result.at('.jobLoc').text.strip
    end

    def company_id(result)
    end

    def job_id(result)
    end

    def job_link(result)
      @job_link ||= result.at('a[id^="position"]')
    end
  end
end
