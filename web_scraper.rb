require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'pry'
require 'nokogiri'
require 'open-uri'
require 'csv'
require_relative 'job'

puts "Create new file? (y/n)"
file_new = gets.chomp

if file_new.downcase == "y"
  puts "type in file name"
  @name = gets.chomp
  #start csv file
  CSV.open("#{@name}.csv", "wb") do |csv|
    csv << ["Job title", "Company name", "Location", "Posting Date", "Link to Post", "Company ID", "Job Id"]
  end
else 
  puts "file name to append"
  @name = gets.chomp
end

#BONUS LATER TASKS 
#get it to crawl through more than one page
#refactor

def how_long_ago(date)
  if date[2..4].downcase == "day"
    post_date = DateTime.now - date[0].to_i
  elsif date[2..5].downcase == "week"
    post_date = DateTime.now - (date[0].to_i * 7)
  end
end

puts "Enter Job Title for search or keyword:"
print ">  "
@keyword = gets.chomp
puts "Enter zip code, city or state"
print "> "
@location = gets.chomp
agent = Mechanize.new

page = agent.get('http://www.dice.com/')

#take in the form
dice_form = page.form_with(:id => "search-form")

#set the two form values
dice_form.q = @keyword
dice_form.l = @location

#establish the button
button = page.form.button_with(:value => "Find Tech Jobs")

# submit the form using that button
page = agent.submit(dice_form, button)

@number_of_items = page.at('h4.pull-left.posiCount.sort span').children.text
@number_of_items = @number_of_items[-2..-1].to_i # @number_of_items.scan(/(\d+)/)[1][0].to_i found a simpler way.
@job_postings = []

@position = 0
while @position < @number_of_items
  
  #SELECTORS
  job_title_selector = "a#position#{@position}.dice-btn-link"
  company_name_selector = "a#company#{@position}.dice-btn-link"
  page_link_selector = "position#{@position}"
  my_id_page = agent.get(page.link_with(:id => page_link_selector).href) #clicks through to page for ids
  find_ids = my_id_page.at('div.company-header-info').text.strip unless my_id_page.at('div.company-header-info') == nil

  # company_and_job_id = find_ids.scan(/(\w+)/) #regex to separate like a boss
  find_location = page.search("ul.list-inline.details").text.strip

  current_job = Job.new

  if page.at(job_title_selector) != nil
    #sort out date
    post_date = page.search("ul.list-inline.details li.posted").map{|item| item.text}[@position]
    current_job.posting_date = how_long_ago(post_date)[5..9]
    current_job.job_title = page.at(job_title_selector).text.strip
    current_job.company_name = page.at(company_name_selector).text.strip
    current_job.job_link = page.link_with(:id => page_link_selector).href
    current_job.company_id = current_job.job_link.split("/")[-2]
    current_job.job_id = current_job.job_link.split("/")[-1]  
    current_job.location = page.search("ul.list-inline.details li.location").map{|item| item.text}[@position]
  end

  @job_postings << current_job
  @position += 1
  puts "Job number #{@position} added!\n"
end

#Add files
CSV.open("#{@name}.csv", 'a+') do |csv|
    # each one of these comes out in its own row.
    @job_postings.each do |opening|
      import_array = []
      import_array << opening.job_title
      import_array << opening.company_name
      import_array << opening.location
      import_array << opening.posting_date
      import_array << opening.job_link
      import_array << opening.company_id
      import_array << opening.job_id
      csv  << import_array
  end
end