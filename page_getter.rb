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
  end


  def get_job_info

  end

end

m = PageGetter.new
m.make_search_query("ruby", "francisco")
m.create_jobs_array(m.search_query)
pp m.jobs