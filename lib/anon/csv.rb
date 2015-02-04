# encoding: utf-8

require 'anon/base'
require 'csv'

module Anon 
  # Replaces the contents of a set of columns with anonymous e-mails.
  class CSV < Base
    def initialize(incoming_filename, outgoing_filename, columns_to_anonymise, has_header=true)
      @incoming_filename = incoming_filename
      @outgoing_filename = outgoing_filename
      @columns_to_anonymise = columns_to_anonymise
      @has_header = has_header
    end

    def anonymise!
      start_progress
      map_lines(@incoming_filename, @outgoing_filename) do |line|
        @columns_to_anonymise.each do |anon_index|
          line[anon_index] = anonymous_email(line[anon_index])
        end
        increment_progress
        line
      end
      complete_progress
    end

    private 

    # Reads each line from the incoming file, processes it using the block
    # and saves the return value of the block to the outgoing file.
    def map_lines(incoming_filename, outgoing_filename)
      ::CSV.open(incoming_filename, 'r') do |infile|
        headers = @has_header ? infile.gets : nil

        ::CSV.open(outgoing_filename, 'w', write_headers: @has_header, headers: headers) do |outfile|
            while inline = infile.gets do
              outfile.puts yield(inline)
            end
        end
      end
    end
  end
end
