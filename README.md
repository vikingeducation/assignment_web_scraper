# assignment_web_scraper
Bottom feeding your way across the web

[A Ruby-based web scraping and parsing project which uses NokoGiri, Mechanize, Open-uri.  From the Viking Code School.](http://www.vikingcodeschool.com)

Authors: Dylan and Vishal.

How does search query work?
-https://www.dice.com/jobs?q=ruby&l=Tampa

base_uri : https://www.dice.com
extension: /jobs?

q      : start of query parameters (e.g. full+stack+ruby)
l      : location (e.g. Los+Angeles%2C+CA, Tampa%2C+FL)
djtype : job type (full+time, part+time, contracts)
&      : parameter delimiter

Filters:
--------
sort=relevance, date
telecommute=true
radius=50
for_loc=Los+Angeles%2C+CA

Example searches:
https://www.dice.com/jobs/advancedResult.html?for_one=Ruby+on+Rails&for_all=&for_exact=&for_none=&for_jt=&for_com=&for_loc=Los+Angeles%2C+CA&sort=relevance&telecommute=true&radius=0&telecommute=true

https://www.dice.com/jobs/advancedResult.html?for_one=&for_all=&for_exact=&for_none=&for_jt=&for_com=&for_loc=Los+Angeles%2C+CA&sort=date&radius=0

