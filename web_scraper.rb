require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'pry'

require 'csv'

class DiceScraper

  DICE_ID_RGX = /detail\/.*?\/(.*?)\/(.*?)\?/

  def initialize
    @agent = Mechanize.new
    #mechanize object waits 0.5secs after every HTML request
    @agent.history_added = Proc.new { sleep 0.5 }
  end

  def scrape_n_save
    mech_obj, time_scraped = scraping_dice
    job_list = post_generator(mech_obj)
    data = scrape_job_post(job_list, time_scraped)
    save_data(data)
  end

  def scraping_dice
    page = @agent.get('http://www.dice.com')
    results_page = nil
    dice_search_page = "http://www.dice.com/jobs"
    @agent.get(dice_search_page) do |page|
      results_page = page.form_with(:name => nil) do |search|
          search.q = 'junior developer'
          search.l = 'New York, NY'
      end.submit
    end
    time = Time.now
    return results_page, time
  end


  def post_generator(mech_obj)
    job_list = mech_obj.search("div[@class=serp-result-content]") #nokogiri obj
  end

  def scrape_job_post(job_list, time_of_scraping)
    job_arr = []
    job_list.each do |job|
      link = job.css("h3 a").attribute("href").value
      id = search_IDs(link)
      employer = job.css("li.employer").text
      title = job.css("h3 a").text.strip
      location = job.css("li.location").text
      date_posted = date_conversion(job.css("li.posted").text, time_of_scraping)
      job_arr << [id, employer, title, link, location, date_posted].flatten!
    end
    job_arr #all job posts on one page
  end

  def save_data(job_arr)
    CSV.open('output.csv', 'a') do |csv|
      job_arr.each do |job|
        csv << job
      end
    end
  end

  def search_IDs(link)
    link.match(DICE_ID_RGX).captures #returns [company_id, post_id]
  end

  def date_conversion(date_str, time_of_scraping)
    date_str = date_str.split(" ")
    seconds_ago = words_to_date(date_str[1])
    date_posted = time_of_scraping - (date_str[0].to_i * seconds_ago)
    date_posted.strftime("%c")
  end

  def words_to_date(word)
    word = word[0..-2] if word[-1] == "s"
    case word.downcase
    when "second"
      1
    when "minute"
      60
    when "hour"
      60*60
    when "day"
      60*60*24
    when "week"
      60*60*24*7
    when "month"
      60*60*24*30
    when "year"
      60*60*24*30
    end
  end

  #def spec_date_scraping(days)
    #need to generalize scraping_dice method: DRY!!!
    #&postedDate=1   <=# is day
    #first_result_page = 'https://www.dice.com/jobs/?for_one=developer&for_loc=New+York%2C+NY&postedDate=1'
    #agent.get(first_result_page) do |page|
    # => results
    #=> links for other pages
    #=> results.links_with(:href => /postedDate=/).each do |link|
    #=> #call method to scrape again...
    # =>next_page = link.click

    ##OR just increment url with "-startPage-2" update number
    ## w/ "-limit-120-jobs.html"
    ## stop when "h4.posiCount span".text's second #(i.e. 3773)/120 + 1 times
#     first_result_page = 'https://www.dice.com/jobs/sort-date-postedDate-1-l-New+York%2C+NY-radius-30-startPage-1-limit-120-jobs.html'
#     page = @agent.get(first_result_page)
#     results_pages = [page]
#     times = 3772/120+1
# =>  until times ==0
  #     @agent.get(first_result_page) do |link|
  # # => link.click
    # => scrape page
  #     end
  # =>  update link
  #     times -= 1
#     end

  # def search_IDs(link)
  #   post_page = agent.results_page.link_with(:href => link)
  #   tree = post_page.parser
  #   company_id = nil
  #   job_id =nil
  #   company_node = tree.css("div.company-header-info")
  #   company_node.each do |node|
  #     if node.content.include?("Dice Id : ")
  #       company_id = node.text.strip
  #     elsif node.content.include?("Position Id : ")
  #       job_id = node.text.strip
  #     end
  #   end
  #   return company_id, job_id
  #  end
  #end

end
