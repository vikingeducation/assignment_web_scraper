# https://www.dice.com/jobs/q-ruby-jtype-Full_Time-sort-date-limit-30-l-94043-radius-5-startPage-1-jobs
require 'pry'
class ScraperUI
  attr_reader :url, :cutoff_date
  def initialize
    @url = nil
    @search_params = {q: nil, jtype: 'Full_Time', l: 94043, radius: 5}
    @page_params = {sort: 'date', limit: '30', startPage: '1'}
    @cutoff_date = nil
  end

  def search(params, cutoff_date)
    @search_params[:q] = params[:q] unless params[:q].nil?
    @search_params[:jtype] = params[:jtype] unless params[:jtype].nil?
    @search_params[:l] = params[:l] unless params[:l].nil?
    @search_params[:radius] = params[:radius] unless params[:radius].nil?
    @url = make_url
    @cutoff_date = cutoff_date
  end

  def make_url
    str = 'https://www.dice.com/jobs/'
    @search_params.each { |k, v| str += "#{k}-#{v}-" }
    @page_params.each { |k, v| str += "#{k}-#{v}-" }
    str += 'jobs'
  end

end

# jobs = ScraperUI.new
# jobs.search({q: 'ruby'})
