# assignment_web_scraper
Bottom feeding your way across the web

[A Ruby-based web scraping and parsing project which uses NokoGiri, Mechanize, Open-uri.  From the Viking Code School.](http://www.vikingcodeschool.com)

Built by [Trevor Elwell](http://trevorelwell.me)

#Simple Instructions: 

**Create a new ScrapeBot**
Something like `a = ScrapeBot.new` will do just fine.

**Search for your desired term**
So if you wanted to look for Ruby jobs you would do: 
`results = a.search("Ruby")`

**Save your results**
`a.save(results)` will get the job done.