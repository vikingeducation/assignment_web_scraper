# SET UP

#   Open the html Document
#   Find the links of each job 
#   loop through them

# SEARCH

#   ( For the First Run, set a Maximum Posted Date, 
#   So the Parsing BREAK if one Post Date is over the Limit )
#
#   For each Job : 
#     
#     Find the Posted Date
#      IF the Posted Date is over the Limit, BREAK
#
#      OTHERWISE : 
#        Create a Struct
#        Find each Tag, and Save them in the Struct
#     Save each Struct in an Array

# SAVE

#   Save to the CSV Document :
#    Create the Document if it doesn't exist already? 
# 
#    Save each Struct Element to the CSV


require 'rubygems'
require 'bundler/setup'
require 'mechanize'
require_relative 'Loader'
require_relative 'Searching'
require_relative 'Saving'
require_relative 'Printing'

class Parser

  def initialize
    @searcher = Searching.new
  end

  def parsing_html( link )

    page = Loader.load( link )
    results = @searcher.parse( page )

    # Why gets.chomp doesnt work on pry ? work on ruby

    print( results )

    unless results.empty?
      puts "Save results? Y or N"
      choice = gets.chomp.upcase
      save( results ) if choice == "Y"
    end
  end

  def print( results )
    Printing.print_search( results )
  end

  def save( results )
    Saving.save( results )
  end
end

parser = Parser.new

parser.parsing_html( 'https://www.dice.com/jobs/sort-date-q-ruby-limit-30-l-New_york-radius-El-jobs.html?searchid=3223042923491' )








