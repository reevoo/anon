# encoding: utf-8

require 'anon/base'
require 'csv'

module Anon
  # Replaces the contents of a set of columns with anonymous e-mails.
  class CSV < Base
    def initialize(incoming_filename, outgoing_filename, columns_to_anonymise, has_header=true)
      @i = File.open(incoming_filename)
      @o = File.open(outgoing_filename, 'w')
      @columns_to_anonymise = columns_to_anonymise
      @has_header = has_header
    end

    def anonymise!
      start_progress
      map_lines do |line|
        @columns_to_anonymise.each do |anon_index|
          line[anon_index] = anonymous_email(line[anon_index])
        end
        increment_progress
        line
      end
      complete_progress
    end

    private

    def input
      @_input ||= ::CSV.new(@i)
    end

    def output
      @_output ||= ::CSV.new(@o, write_headers: @has_header, headers: @headers)
    end

    # Reads each line from the incoming file, processes it using the block
    # and saves the return value of the block to the outgoing file.
    def map_lines
      @headers = @has_header ? input.gets : nil
      while inline = input.gets do
        output.puts yield(inline)
      end
    end
  end
end
