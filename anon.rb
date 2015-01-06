#!/usr/bin/env ruby
# encoding: utf-8

# anon
# Anonymises e-mail addresses in a block of text.
#
# All in one file for ease of transfer/use by the rest of Reevoo.

require 'csv'

module Anon
  # Anonymiser base class
  class Anonymiser

    def self.anonymise(*args)
      new(*args).anonymise!
    end

    protected

    def anonymous_email
      @anonymised_emails ||= 0
      @anonymised_emails += 1

      "anon#{@anonymised_emails}@reevoo.com"
    end
  end

  # Anonymises any detected e-mail address in a text file.
  class TextAnonymiser < Anonymiser
    # From the email regex research: http://fightingforalostcause.net/misc/2006/compare-email-regex.php
    # Authors: James Watts and Francisco Jose Martin Moreno
    EMAIL_REGEX = /([\w\!\#\z\%\&\'\*\+\-\/\=\?\\A\`{\|\}\~]+\.)*[\w\+-]+@((((([a-z0-9]{1}[a-z0-9\-]{0,62}[a-z0-9]{1})|[a-z])\.)+[a-z]{2,6})|(\d{1,3}\.){3}\d{1,3}(\:\d{1,5})?)/i

    def initialize(incoming_filename, outgoing_filename)
      @incoming_filename = incoming_filename
      @outgoing_filename = outgoing_filename
    end

    def anonymise!
      map_lines(@incoming_filename, @outgoing_filename) do |line|
        anonymise_line(line)
      end
    end

    private 

    # Reads each line from the incoming file, processes it using the block
    # and saves the return value of the block to the outgoing file.
    def map_lines(incoming_filename, outgoing_filename)
      File.open(incoming_filename, 'r') do |infile|
        File.open(outgoing_filename, 'w') do |outfile|
          infile.each_line do |inline|
            outfile.puts yield(inline)
          end
        end
      end
    end

    def anonymise_line(line)
      line.gsub(EMAIL_REGEX) { anonymous_email }
    end    
  end

  # Replaces the contents of a set of columns with anonymous e-mails.
  class CsvAnonymiser < Anonymiser
    def initialize(incoming_filename, outgoing_filename, columns_to_anonymise, has_header=true)
      @incoming_filename = incoming_filename
      @outgoing_filename = outgoing_filename
      @columns_to_anonymise = columns_to_anonymise
      @has_header = has_header
    end

    def anonymise!
      map_lines(@incoming_filename, @outgoing_filename) do |line|
        @columns_to_anonymise.each do |anon_index|
          line[anon_index] = anonymous_email
        end

        line
      end
    end

    private 

    # Reads each line from the incoming file, processes it using the block
    # and saves the return value of the block to the outgoing file.
    def map_lines(incoming_filename, outgoing_filename)
      CSV.open(incoming_filename, 'r') do |infile|
        headers = @has_header ? infile.gets : nil

        CSV.open(outgoing_filename, 'w', write_headers: @has_header, headers: headers) do |outfile|
            while inline = infile.gets do
              outfile.puts yield(inline)
            end
        end
      end
    end

    def anonymise_line(line)
      line.gsub(EMAIL_REGEX) { anonymous_email }
    end
  end
end

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

USAGES
------
Anonymise any valid e-mail addresses:
  ruby anon.rb text INFILE OUTFILE

Replace the data in specific columns of a CSV:
  ruby anon.rb csv INFILE OUTFILE COL1,COL2
  ruby anon.rb csv INFILE OUTFILE COL1,COL2 noheader
Note that the first column is column 0 when numbering columns.

Show this message:
  ruby anon.rb help"
  end
end