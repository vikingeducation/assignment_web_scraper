# assignment_web_scraper
Bottom feeding your way across the web

[A Ruby-based web scraping and parsing project which uses NokoGiri, Mechanize, Open-uri.  From the Viking Code School.](http://www.vikingcodeschool.com)

Kit & Kelsey

query address: "https://www.dice.com/jobs?q=#{serch+term}"



scraper.history_added = Proc.new { sleep 0.5 }


Increment Page-#{i} until 404'ed!
https://www.dice.com/jobs/q-rails-limit-100-jobs.html

<div class="serp-result-content">
  <h3>
    <a id="position{number}" title="job description" href="actual link">
  </h3>
  <div class="short-desc">
    Short description goes here
  </div>
  <ul class="list-inline details">
    <li class="employer"><span class="hidden-md"><a id="company{number}" href="link to company page">Employer</a></span></li>
    <li class="location">Location</li>
    <li class="posted">Date Posted</li>
