require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'pry'

page = Nokogiri::HTML(open("http://www.google.com"))
binding.pry