require 'csv'
require_relative 'web_scrapper'



class ResultsSaver

  def initialize(scrapper = WebScrapper.new.parse_all_job_adverts)
    @scrapper = scrapper
  end

  def save_in_file
    CSV.open('current_jobs.csv', 'a') do |csv|
      csv << %w[JOB_TITLE COMPANY_NAME CITY DATE URL]
      @scrapper.each { |array| csv << array }
    end
  end

end

ResultsSaver.new.save_in_file