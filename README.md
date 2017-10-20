#  Web Scraper

In this project I have created own  Web Scraper using Mechanize gem. The crawler which pulls down the latest jobs meeting user's search criteria into a spreadsheet document.

* `results_saver.rb` - Saves search results to `current_jobs.csv` file
* `web_scraper.rb` - Mechanize Gem at work, which is the code that is scrapeing Ineed.com page by page, using specific markup points to detect keyowrds, names etc.


## Getting Started

If you want to quick run some the examples to see the code in action, run
```
$ ruby results_saver.rb
```
from the project directory. The Scraper will go through the Indeed.com searching for jobs including `ruby` and `Dublin` in the job offer. If you like to choose your own place and keyword, run:
```
irb
load 'results_saver.rb'
results = ResultsSaver.new(YOUR_CITY, YOUR_KEYWORD)
results.save_in_file
```

The above will result in a new `current_jobs.csv` file created. This can be copied and pasted to Excell. This data can be then easily oragnized using Delimited Text Edition [Guide on Hot to Do it](http://www.informit.com/articles/article.aspx?p=2027553&seqNum=5)

Enjoy your jobs scraper!

## Authors

* **Dariusz Biskupski** - *Initial work* - https://dariuszbiskupski.com


## Acknowledgments

It is the assignment created for [Viking Code School](https://www.vikingcodeschool.com/)
