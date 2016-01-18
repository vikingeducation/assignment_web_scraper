require 'rubygems'
require 'mechanize'


class PageGetter

  HOME_PAGE = 'http://www.dice.com/'

  attr_reader :page, :agent

  def initialize
    @agent = Mechanize.new
    @page = nil
  end

  def visit_url
    @page = agent.get(HOME_PAGE)
  end




end


m = PageGetter.new
m.visit_url
p m.page