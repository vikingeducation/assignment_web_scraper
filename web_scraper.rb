require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require 'pry'
require 'nokogiri'
require 'open-uri'
require 'csv'

@ary_of_arys = []
def add_to_main_array(input)
  i = 0
  input.each do |job|
    @ary_of_arys[i] << job
  end
  i += 1
end

#STILL NEED TO DO LINK POSTING CAN'T GET FUCKING URL

# puts "Enter Job Title for search or keyword:"
# print ">  "
# @keyword = gets.chomp
# puts "Enter zip code, city or state"
# print "> "
# @location = gets.chomp
agent = Mechanize.new

page = agent.get('http://www.dice.com/')

#take in the form
dice_form = page.form_with(:id => "search-form")

#set the two form values
dice_form.q = "ruby"  #@keyword
dice_form.l = "new york city"  #@location



#establish the button
button = page.form.button_with(:value => "Find Tech Jobs")

# submit the form using that button
page = agent.submit(dice_form, button)

# binding.pry

#syntax for stuff


#start csv file
CSV.open("my_jobs.txt", "wb") do |csv|
  csv << ["Job title", "Company name", "Link to posting on Dice", "Location", "Posting date", "Company ID", "Job ID"]
end

#job_name
#still need to do location
my_job_array = []
ary_of_arys = []

@position = 0
validity_checker = true
while @position < 3 #validity_checker
  job_title_selector = "a#position#{@position}.dice-btn-link"
  company_name_selector = "a#company#{@position}.dice-btn-link"
  page_link_selector = "position#{@position}"
  my_id_page = agent.get(page.link_with(:id => page_link_selector).href) #clicks through to page for ids
  find_ids = my_id_page.at('div.company-header-info').text.strip #selects area of relevant text
  company_and_job_id = find_ids.scan(/(\d+)/) #regex to separate like a boss

  #company id and job id


  # binding.pry

  # find_ids(page.link_with(:id => page_link_selector).href)

  # binding.pry


  if page.at(job_title_selector) != nil
    my_job_array << page.at(job_title_selector).text.strip
    my_job_array << page.at(company_name_selector).text.strip
    my_job_array << page.link_with(:id => page_link_selector).href
    my_job_array << company_and_job_id[0][0] #company dice id
    my_job_array << company_and_job_id[1][0] #position id
  else
    validity_checker = false
  end
  @position += 1
  puts @position
end

binding.pry

def find_ids(page_to_check)
  (page_to_check)
end

locations = page.search("li.location").text(" ")

#first time to initialize everything
my_job_array.each do |job|
  @ary_of_arys << job
end








#second time adds in

  binding.pry



#add to it
CSV.open("my_jobs.txt", "a+") do |csv|
  csv << something
end



page.links.each do |link|
  puts link.text
end
