# assignment_web_scraper
Bottom feeding your way across the web

Author : Behdad Analui

[A Ruby-based web scraping and parsing project which uses NokoGiri, Mechanize, Open-uri.  From the Viking Code School.](http://www.vikingcodeschool.com)



---> HTML Params for different search results


# Searching : "Web Developer" in "Los Angeles, CA"

# page 1 :
https://www.dice.com/jobs?q=Web+Developer&l=Los+Angeles%2C+CA&searchid=4695930607292

This result is showing with already filtered: Distance = "Within 30 miles"

# page 2 :
https://www.dice.com/jobs/q-Web_Developer-limit-30-l-Los_Angeles%2C_CA-radius-30-startPage-2-limit-30-jobs?searchid=3243616771397

# Add filter --> Company Segment = "Recruiter"
https://www.dice.com/jobs/q-Web_Developer-l-Los_Angeles%2C_CA-dcs-Recruiter-radius-30-jobs.html?searchid=3658329038016

# Add filter --> Distance = "Within 10 miles"
https://www.dice.com/jobs/q-Web_Developer-limit-30-l-Los_Angeles%2C_CA-radius-10-jobs.html?searchid=9229563461169

# Add filter --> Distance = "Exact Location"
https://www.dice.com/jobs/q-Web_Developer-limit-30-l-Los_Angeles%2C_CA-radius-El-jobs.html?searchid=2207553450629

# Add filter --> Title = "Software Engineer"
https://www.dice.com/jobs/q-Web_Developer-l-Los_Angeles%2C_CA-djt-Software_Engineer-radius-El-jobs.html?searchid=1760823245268

# Add filter --> Company = "Praedicat, Inc."
https://www.dice.com/jobs/q-Web_Developer-dc-Praedicat%2C+Inc.-limit-30-l-Los_Angeles%2C_CA-radius-El-jobs.html?searchid=5889586703863

# Add filter --> Employment Type = "Part-Time"
https://www.dice.com/jobs/jtype-Part%20Time-q-Web_Developer-limit-30-l-Los_Angeles%2C_CA-radius-El-jobs.html?searchid=8622557635651

# Add filter --> Telecommute = "Yes"
https://www.dice.com/jobs/q-Web_Developer-l-Los_Angeles%2C_CA-dtco-true-radius-El-jobs.html?searchid=2773396522422

# Add bunch of filters

Within 10 miles
Java Developer
Los Angeles, CA
Rose IT Corp.
Full-Time and Part-Time and Contracts(Contract Independent, C2H W2)
Yes

https://www.dice.com/jobs/q-Web_Developer-djt-Java+developer-dc-Rose+IT+Corp.-jtype-Full+Time+OR+Part+Time+OR+Contract+Independent+OR+C2H+W2-dtco-true-limit-30-l-Los_Angeles%2C_CA-radius-10-jobs.html?searchid=4066268815121


---> HTML Params for a single job page with title 'Web Application Firewall Engineer - remote'

https://www.dice.com/jobs/detail/Web-Application-Firewall-Engineer-%26%2345-remote-CGS-Los-Angeles-CA-90017/10477632/BHJOB31_326?icid=sr1-1p&q=Web%20Developer&l=Los%20Angeles,%20CA