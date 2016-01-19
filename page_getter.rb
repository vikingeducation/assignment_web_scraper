require 'rubygems'
require 'mechanize'


class PageGetter

  HOME_PAGE = 'http://www.dice.com/jobs'

  attr_reader :full_page, :agent, :search_query, :jobs

  def initialize
    @agent = Mechanize.new
    @agent.history_added = Proc.new { sleep 0.5 }
    @full_page = nil
    @search_query = nil
    @jobs = []
  end

  def make_search_query(search_term, location)
    @search_query = HOME_PAGE + "?q=#{search_term}" + "&l=#{location}"
  end


  def create_jobs_array(target_url)
    @full_page = agent.get(target_url)
    all_links = @full_page.search("#serp")
    root = all_links[0]
    # p root

    stack = []
    stack << root
    while node = stack.pop
      node.children.each do |child|
        @jobs << child.attributes
        @jobs << child.children
        stack << child
      end
    end
    @jobs.compact
  end


  def get_job_info
    listings = []  # all 30 on the page
    # [listing0, listing1, listing2]
    listing = {}
    i = 0

    (0..29).each_with_index do |test, index|
      position_number = "position" + index.to_s
      company_number = "company" + index.to_s
      current_listing = ""

      @jobs.each_with_index do |info_block, index|
        if info_block.nil? 
          next
        elsif !info_block.is_a? Hash
          next
        elsif info_block['id'].nil?
          next
        elsif info_block['id'].value.nil?
          next
        else
          if info_block['id'].value == position_number
            # print "position0 index: #{index}"
            listing['job_title'] = info_block['title'].value
            listing['link'] = info_block['href'].value
            listing['job_id'] = info_block['href'].value
          end
          if info_block['id'].value == company_number
            # print "company0 index: #{index}"
            listing['company_id'] = info_block['href'].value
            listing['company_name'] = @jobs[index + 1].text
            # listing['company_location'] = @jobs[index + 5].text
            # listing['posting_date'] = @jobs[index + 9].text
          end
        end
        # listings[index] = listing
      end
      # listings << listing
      # listings = ["listing"=> data, "listing"=> new_data]
    end
    print listing
  end

  def visit_all_links
    # go to page with links
    @full_page = agent.get(@search_query)
    # all_links = @full_page.search("#serp")

    count = 0
    queue = []
    # get list of links to visit
    @full_page.links.each do |link|
      queue << link
      count += 1
    end
    puts "We need to visit #{count} links."

    visited = 0
    # go to each link in order, directly from the previous one
    queue.each do |link|
      agent.get(link)
      # call another function to scrape the new page
      visited += 1
      break if visited == 4
    end
    puts "We have visited #{visited} links."
    # stop after no more links

  end

end


m = PageGetter.new
m.make_search_query("ruby", "francisco")
# m.visit_all_links
m.create_jobs_array(m.search_query)
m.get_job_info
