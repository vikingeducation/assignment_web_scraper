require 'rubygems'
require 'mechanize'
require 'bundler/setup'

agent = Mechanize.new
page = agent.get('https://www.dice.com/jobs/q-web_development-jtype-Full+Time-sort-date-limit-30-l-San_Francisco%2C_CA-radius-10-jobs.html?searchid=6756117910756')
