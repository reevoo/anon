# encoding: utf-8

require 'anon/base'

module Anon
  # Anonymises any detected e-mail address in a text stream
  class Text < Base
    # From the email regex research: http://fightingforalostcause.net/misc/2006/compare-email-regex.php
    # Authors: James Watts and Francisco Jose Martin Moreno
    EMAIL_REGEX = /[^\s@]+@[^\s@\.]+\.[^\s@]+/i

    # Returns a new instance of the Text anonymiser
    # @param input [IO, #gets] the stream to read from
    # @param output [IO, #puts] the stream to write to
    def initialize(input, output)
      @input = input
      @output = output
    end

    # Anonymises any e-mail addresses found in the text
    def anonymise!
      start_progress
      map_lines do |line|
        line = anonymise_line(line)
        increment_progress
        line
      end
      complete_progress
    end

    private

    attr_reader :input, :output

    # Reads each line from the incoming file, processes it using the block
    # and saves the return value of the block to the outgoing file.
    def map_lines
      while (inline = input.gets)
        output.puts yield(inline)
      end
    end

    def anonymise_line(line)
      line.gsub(EMAIL_REGEX) { |email| anonymous_email(email) }
    end
  end
end
