require 'rubygems'
require 'bundler/setup'
require 'mechanize'

agent = Mechanize.new
agent.history_added = Proc.new { sleep 0.5 }

page = agent.get('https://www.dice.com/jobs')

search_form = page.form_with(:id => 'searchJob')

# Job title or keywords
search_form.q = "Web developer"

# Location ~ City, ST
search_form.l = "Boston, MA"

page = agent.submit(search_form)

# pp page

# grab each link and click on it
  # in div class="serp-result-content" > h3 > a


# Job title
#    -> div id="header-wrap" > h1 id="jt"
# Company name
#    ^ + li class="employer"
# Link to posting on Dice
#    -> current page
# Location
#    ^ + li class="location"
# Posting date (not a relative date like "x weeks ago" because that will quickly be meaningless)
#    ^ + li class="posted" (compare to current date)
# Company ID
#    -> div class="company-header-info" 2nd "row"
# Job ID
#    -> div class="company-header-info" 3rd "row"