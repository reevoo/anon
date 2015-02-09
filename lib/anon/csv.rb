# encoding: utf-8

require 'anon/base'
require 'csv'

module Anon
  # Replaces the contents of a set of columns with anonymous e-mails.
  class CSV < Base
    def initialize(input, output, columns_to_anonymise, has_header = true)
      @input = input
      @output = output
      @columns_to_anonymise = columns_to_anonymise
      @has_header = has_header
    end

    # Anonymises all content of the columns set in the initializer
    def anonymise!
      start_progress
      map_lines do |line|
        columns_to_anonymise.each do |anon_index|
          line[anon_index] = anonymous_email(line[anon_index])
        end
        increment_progress
        line
      end
      complete_progress
    end

    private

    attr_reader :has_header

    def input
      @_input ||= ::CSV.new(@input, headers: has_header)
    end

    def output
      @_output ||= ::CSV.new(@output, write_headers: has_header, headers: headers)
    end

    def columns_to_anonymise
      @_col_memo ||= @columns_to_anonymise.map { |c| Integer(c) }
    rescue ArgumentError
      @_col_memo = @columns_to_anonymise
    end

    # Reads each line from the incoming file, processes it using the block
    # and saves the return value of the block to the outgoing file.
    def map_lines
      while (inline = input.gets)
        output.puts yield(inline)
      end
    end

    def headers
      input.headers
    end
  end
end
