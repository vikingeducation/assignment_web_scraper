require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require_relative 'result'

class Searcher
  attr_reader :results
  def initialize(opts={})
    @results = []
  end

  def search(opts={})
    run_search(opts)
    parse_results
  end

  def run_search(opts)
    for_one = opts[:for_one] ? opts[:for_one] : ''
    for_all = opts[:for_all] ? opts[:for_all] : ''
    for_exact = opts[:for_exact] ? opts[:for_exact] : ''
    for_none = opts[:for_none] ? opts[:for_none] : ''
    for_jt = opts[:for_jt] ? opts[:for_jt] : ''
    for_com = opts[:for_com] ? opts[:for_com] : ''
    for_loc = opts[:for_loc] ? opts[:for_loc] : ''
    radius = opts[:radius] ? opts[:radius] : ''
    jtype = opts[:jtype] ? opts[:jtype] : ''
    posteddate = opts[:one] ? opts[:one] : '30'
    sort = opts[:sort] ? opts[:sort] : 'relevance'
    telecommute = opts[:telecommute] ? opts[:telecommute] : ''
    limit = opts[:limit] ? opts[:limit] : '3'
    m = Mechanize.new
    @page = m.get("https://www.dice.com/jobs/advancedResult.html?for_one=#{for_one}&for_all#{for_all}=&for_exact=#{for_exact}&for_none=#{for_none}&for_jt=#{for_jt}&for_com=#{for_com}&for_loc=#{for_loc}&jtype=#{jtype}&limit=#{limit}&radius=#{radius}&postedDate=#{posteddate}")
  end

  def parse_results
    results = @page.search('div.complete-serp-result-div')
    results.each_with_index do |result, i|
      @results << Result.new(result.search("ul.list-inline li h3 a")[0][:title],
                             result.search("ul.details li.employer a")[0].text,
                             result.search("ul.list-inline li h3 a")[0][:href],
                             result.search("ul.details li.location")[0][:title],
                             convert_date(result.search('ul.details li.posted')[0].text).strftime("%d/%m/%Y, %H:%M"),
                             results.search('ul.list-inline li h3 a')[i][:href].match(/dice.com\/jobs\/detail\/.*\/(.*)\//)[1],
                             results.search('ul.list-inline li h3 a')[i][:href].match(/dice.com\/jobs\/detail\/.*\/.*\/(.*)?\?/)[1]
                             )
    end
  end

  def convert_date(date)
    # xx hours ago
    if d = date.match(/(.*?)hour(s?) ago/)
      return Time.new - ( d[1].to_i * 60 * 60 )
      # xx days ago
    elsif d = date.match(/(.*?)day(s?) ago/)
      return Time.new - ( d[1].to_i * 60 * 60 * 24 )

    elsif d = date.match(/(.*?)week(s?) ago/)
      return Time.new - ( d[1].to_i * 60 * 60 * 24 * 7)
    end
  end

end
