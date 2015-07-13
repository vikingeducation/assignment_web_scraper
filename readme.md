assignment_web_scraper
Bottom feeding your way across the web

Olga and Mike

A Ruby-based web scraping and parsing project which uses NokoGiri, Mechanize, Open-uri. From the Viking Code School.




Method for page crawling
  -click the date sort link
  -check the first result's date 
  -if the date is < 1 month ago click next page link (we already pushed  to csv)
  -if the date is > 1 month ago then no longer click next
  -if there is no "next" link then end process