require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'csv'

class Scraper

  def initialize
    @agent = Mechanize.new
  end

