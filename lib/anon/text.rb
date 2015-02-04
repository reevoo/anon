# encoding: utf-8

require 'anon/base'

module Anon
  # Anonymises any detected e-mail address in a text file.
  class Text < Base
    # From the email regex research: http://fightingforalostcause.net/misc/2006/compare-email-regex.php
    # Authors: James Watts and Francisco Jose Martin Moreno
    EMAIL_REGEX = /([\w\!\#\z\%\&\'\*\+\-\/\=\?\\A\`{\|\}\~]+\.)*[\w\+-]+@((((([a-z0-9]{1}[a-z0-9\-]{0,62}[a-z0-9]{1})|[a-z])\.)+[a-z]{2,6})|(\d{1,3}\.){3}\d{1,3}(\:\d{1,5})?)/i

    def initialize(incoming_filename, outgoing_filename)
      @incoming_filename = incoming_filename
      @outgoing_filename = outgoing_filename
    end

    def anonymise!
      start_progress
      map_lines(@incoming_filename, @outgoing_filename) do |line|
        line = anonymise_line(line)
        increment_progress
        line
      end
      complete_progress
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
      line.gsub(EMAIL_REGEX) { |email| anonymous_email(email) }
    end   
  end
end
