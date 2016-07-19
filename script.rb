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
job_form.l =  "Hanover, NH"

page = d.agent.submit(job_form, job_form.buttons.first)

pp page

parsed_page = d.agent.page.parser
all_the_divs = parsed_page.css('div')
#puts "There are #{all_the_divs.count} div tags. Here they are:"
#pp parsed_page
#pp all_the_divs
