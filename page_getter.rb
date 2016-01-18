require 'rubygems'
require 'mechanize'


class PageGetter

  HOME_PAGE = 'http://www.dice.com/jobs'

  attr_reader :page, :agent, :query

  def initialize
    @agent = Mechanize.new
    @page = nil
    @query = nil
  end

  def visit_url(target)
    @page = agent.get(target)
  end

  def make_query(search_term, location)
    @query = HOME_PAGE + "?q=#{search_term}" + "&l=#{location}"
  end

end


m = PageGetter.new
m.make_query("ruby", "francisco")
m.visit_url(m.query)
p m.page