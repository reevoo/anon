# !/usr/bin/ruby
# encoding: utf-8

# ReturnToSender
# Anonymises e-mail addresses in a block of text.
#
# USAGE:
# ruby r2s.rb <INFILE> <OUTFILE>

require 'tempfile'
require 'fileutils'

class ReturnToSender

  # From the email regex research: http://fightingforalostcause.net/misc/2006/compare-email-regex.php
  # Authors: James Watts and Francisco Jose Martin Moreno
  EMAIL_REGEX = /([\w\!\#\z\%\&\'\*\+\-\/\=\?\\A\`{\|\}\~]+\.)*[\w\+-]+@((((([a-z0-9]{1}[a-z0-9\-]{0,62}[a-z0-9]{1})|[a-z])\.)+[a-z]{2,6})|(\d{1,3}\.){3}\d{1,3}(\:\d{1,5})?)/i

  def self.anonymise(incoming_filename, outgoing_filename)
    new(incoming_filename, outgoing_filename).anonymise!
  end

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

  def anonymous_email
    @anonymised_emails ||= 0
    @anonymised_emails += 1

    "anon#{@anonymised_emails}@reevoo.com"
  end
end

fail "No filename specified" if ARGV[0].nil? || ARGV[1].nil?
ReturnToSender.anonymise(ARGV[0], ARGV[1])