require_relative 'job_links_for_locations'
require_relative 'job_details'
require 'csv'

class DiceScraper

  def initialize(keywords, zipcodes)
    unless keywords.is_a?(Array) && zipcodes.is_a?(Array)
      raise "Initialize with keyword(s) and zipcode(s) to search, each in an array"
    end

    @keywords = keywords
    @zipcodes = zipcodes
  end


  def build_csv

    links = JobLinksForLocations.new(@keywords, @zipcodes).get_links
    jobs = JobDetails.new(links).get_details

    # Add headings to file based off Job Struct, if the file isn't already there
    unless File.exist?('jobs.csv')
      headings = Job.new
      CSV.open('jobs.csv', 'a') do |csv|
        csv << headings.members
      end
    end

    CSV.open('jobs.csv', 'a') do |csv|

      jobs.each do |job|
        csv << job.to_a
      end

    end

  end



  
  
end