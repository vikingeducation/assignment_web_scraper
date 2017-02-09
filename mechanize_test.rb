# mechanize test

require 'rubygems'
require 'bundler/setup'
require 'mechanize'

agent = Mechanize.new

page = agent.get('http://google.com/')

google_form = page.form('f')

another_form = page.form_with(:id => "some_id")
another_form = page.form_with(:action => "/some_path")

google_form.q = 'ruby mechanize'

page = agent.submit(google_form)

pp page
