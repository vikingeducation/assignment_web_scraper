require 'rubygems'
require 'bundler/setup'
require 'pry-byebug'
require 'mechanize'
require 'date'
require 'csv'

class MechScraper

  POSTING = '#serp ul li.posted'
  LOCATION = '#serp ul li.location'
  COMPANY = '#serp ul li span.hidden-xs a'

  def initialize(search_keywords, location)
    @job_ids, @company_ids = [], []
    a = Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari' }
    search_jobs(a, search_keywords, location)
    @job_links = job_links_parser
    @job_titles = job_titles_parser
    @posting_dates = get_gregor_date(parse_results(POSTING))
    @locations = parse_results(LOCATION)
    @company_names = parse_results(COMPANY)
  end

  def search_jobs(mech_instance, job_keywords, location)
    mech_instance.get('https://www.dice.com/jobs?q=&l=') do |page|
       job_pages = page.links.find_all { |l| l.attributes.parent.name == 'h3' }
       ids_parser(job_pages[0..29])
       @search_result = page.form_with(:id => "searchJob") do |form|
         form.q = job_keywords
         form.l = location
       end.submit
    end
  end

  def job_links_parser
    job_links = @search_result.links_with(:id => /position\d+/ ).map{ |link| link.href}
    job_links = job_links[0..29]
  end

  def ids_parser(job_link_array)
    job_link_array.each do |link|
      job_posting = link.click
      job_posting.search('div.company-header-info div.row').each do |noko_obj|
        text = noko_obj.text
        populate_job_company_ids(text)
      end
      @company_ids = @company_ids[0..29]
      @job_ids = @job_ids[0..29]
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
    job_titles = @search_result.search('#serp h3 a').text.split(/\n\t/).map(&:strip)
    job_titles.select!{|item| !item.empty?}[0..29]
  end


  def parse_results(search_criteria)
    results_array = []
    @search_result.search(search_criteria).each do |obj|
      results_array << obj.text
    end
    results_array = results_array[0..29]
  end

  def get_gregor_date(array)
    current_time = Time.now
    array.map do |rel_time|

      # binding.pry
      next unless match = rel_time.match(/\d+/)
      num = match[0].to_i
      if rel_time.include?("hour")
        Time.new(current_time.year, current_time.month, current_time.day, [current_time.hour - num, 0].max)
      elsif rel_time.include?("day")
        Time.new(current_time.year, current_time.month, current_time.day - [0, num].max)
      elsif rel_time.include?("week")
        Time.new(current_time.year, current_time.month, current_time.day - (7 * [0, num].max))
      elsif rel_time.include?("month")
        Time.new(current_time.year, current_time.month - [num, 0].max, current_time.day )
      else
        Time.now
      end
    end
  end

  def create_csv_file(filename = 'jobs_search.csv')
    CSV.open(filename, "w+") do |csv|
      csv << ['Job Title ', 'Company Name ', 'Link to Dice Posting ', 'Location ',
        'Posting Date ', 'Company Id ', 'Job Id ']
      (0..29).each do |i|
        csv << [@job_titles[i], @company_names[i], @job_links[i], @locations[i], @posting_dates[i].strftime("%B %-d, %Y"), @company_ids[i], @job_ids[i]]
      end
    end
  end
end

# scrape_job = MechScraper.new('rails developer', 'Orange County, CA')
# scrape_job.create_csv_file('refactored_search.csv')
