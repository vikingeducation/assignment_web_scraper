# Dice.com Web Scraper with Nokogiri and Mechanize

With this application, you can scrape job listings on https://www.dice.com. You can pass a query and a location and get back a csv with the job listing title, company, link to posting, location, date of posting, Dice ID, and posting ID.

## Getting Started

First fork this repo and copy the link to your fork of the repo. Then enter the following lines into your command line.

```
git clone "your-link-to-your-fork-of-repo"
cd assignment_web_scraper
irb
load 'dice_scraper.rb'
d = DiceScraper.new("software engineer", "fresno, ca")
d.create_csv("path/to/file.csv")

```

Navigate to the path you specified in your csv and take a look at your results in your favorite CSV viewer.

### Prerequisities

You will need to have Ruby and IRB (the ruby REPL) installed on your computer to run this program.
See [this link](https://www.ruby-lang.org/en/downloads/) to download Ruby.


## Built With

* Sublime
* Nokogiri
* Mechanize

## Acknowledgments
Thanks to [Mike Lee](https://github.com/asackofwheat) for collaborating with me on this one.
Thanks to [Viking Code School](https://github.com/vikingeducation) for creating this assignment.

# Get in touch if you are having any issues!

