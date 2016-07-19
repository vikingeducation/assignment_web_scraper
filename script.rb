require 'rubygems'
require 'bundler/setup'
require 'mechanize'

class DiceScraper 
  attr_reader :agent
  def initialize 
    @agent = Mechanize.new
  end
end

d = DiceScraper.new

#form
page = d.agent.get('https://www.dice.com/')
job_form = page.form_with(:action => "/jobs")

#input fields
job_form.q = "Web Developer"
job_form.l =  "New York"

page = d.agent.submit(job_form, job_form.buttons.first)
pp job_form