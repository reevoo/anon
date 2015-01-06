#!/usr/bin/env ruby
# encoding: utf-8

require 'csv'
require 'time_difference'

$LOAD_PATH.unshift File.dirname(__FILE__)
require 'anon/anonymiser'
require 'anon/text_anonymiser'
require 'anon/csv_anonymiser'

if __FILE__ == $0
  case(ARGV[0])
  when 'text'
    abort "No filename specified" if ARGV[1].nil? || ARGV[2].nil?
    Anon::TextAnonymiser.anonymise(ARGV[1], ARGV[2])
  when 'csv'
    abort "No filename specified" if ARGV[1].nil? || ARGV[2].nil?
    
    abort "No columns specified" if ARGV[3].nil?
    cols = ARGV[3].split(',').map(&:to_i) || abort("Columns should be specified as 1,2,3")

    show_header = ARGV[4] != 'noheader'

    Anon::CsvAnonymiser.anonymise(ARGV[1], ARGV[2], cols, show_header)
  else # includes 'help'
    puts "Anonymises files.
ruby anon.rb [text|csv] INFILE OUTFILE [options]

There are two types of processing:
  text - anonymise any valid e-mail address in the text
  csv  - anonymise the content of a specific column in a CSV

To anonymise any e-mail address in a file, use:
  ruby anon.rb text in.txt out.txt

For CSV, you must specify the columns to anonymise, for example:
  ruby anon.rb csv in.csv out.csv 0,2,5
Note that the first column is column 0 when numbering columns.

You can also specify the noheader option if the CSV has no header:
  ruby anon.rb csv in.csv out.csv 1 noheader"
  end
end