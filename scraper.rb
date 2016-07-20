require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

class MechScraper

  def initialize(search_keywords, location)
    a = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
    search_jobs(search_keywords, location))
    job_links_parser
    @posting_dates = parse_results('#serp ul li.posted')
    @job_ids = []
    @company_ids = []
  end

  def search_jobs(job_keywords, location)
    a.get('https://www.dice.com/jobs?q=&l=') do |page|
       jobs_links = page.links.find_all { |l| l.attributes.parent.name == 'h3' }
       @jobs_links = jobs_links[0..29]
       @search_result = page.form_with(:id => "searchJob") do |form|
         form.q = job_keywords
         form.l = location
       end.submit
    end
  end

  def job_links_parser
    job_links = @search_result.links_with(:id => /position\d+/ ).map{ link.href}
    job_links = job_links[0..29]
  end


    def id_parser(job_link_array)
      jobs_link_array.each do |link|
        job_posting = link.click
        job_posting.search('div.company-header-info div.row').each do |noko_obj|
          text = noko_obj.text
          populate_job_company_ids(text, company_ids, job_ids)
        end
    end

    def populate_job_company_ids(text)
      if text.include? "Dice Id"
        @company_ids << text.strip
      elsif text.include? "Position Id"
        @job_ids << text.strip
      end
    end

    def job_titles_parser
      job_titles = search_result.search('#serp h3 a').text.split(/\n\t/).map(&:strip)
      job_titles.select!{|item| !item.empty?}[0..29]
    end


    company_names = []
    search_result.search('#serp ul li span.hidden-xs a').each do |obj|
      company_names << obj.text.strip
    end
    company_names = company_names[0..29]

    locations = []
    search_result.search('#serp ul li.location').each do |location|
      locations << location.text
    end
    locations = locations[0..29]


    posting_dates = []
    search_result.search('#serp ul li.posted').each do |obj|
      posting_dates << obj.text
    end
    posting_dates = posting_dates[0..29]

    @posting_dates = parse_results('#serp ul li.posted')


    def parse_results(search_criteria)
      results_array = []
      @search_result.search(search_criteria).each do |obj|
        results_array << obj.text
      end
      results_array = results_array[0..29]
    end


    def get_gregor_date(array)
      posting_dates = posting_dates.map do |rel_time|
        num = rel_time.match(/\d+/)[0].to_i
        if rel_time.include?("hour")
          Time.new(current_time.year, current_time.month, current_time.day, current_time.hour - num)
        elsif rel_time.include?("day")
          Time.new(current_time.year, current_time.month, current_time.day - num)
        elsif rel_time.include?("week")
          Time.new(current_time.year, current_time.month, current_time.day - (7 * num))
        end
      end
    end




    CSV.open("file.csv", "w+") do |csv|
      csv << ['Job Title ', 'Company Name ', 'Link to Dice Posting ', 'Location ',
        'Posting Date ', 'Company Id ', 'Job Id ']
      csv << ['________________________________________________________________________________________']
      (0..29).each do |i|
        csv << [job_titles[i], company_names[i], job_links[i], locations[i], posting_dates[i].strftime("%B %-d, %Y"), company_ids[i], job_ids[i]]
      end

    end
end
