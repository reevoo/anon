module Anon
  # Anonymiser base class
  module CLI

    def parse!(args)
      command, *command_args = args
      if respond_to?(command)
        send(command, *command_args)
      else
        help
      end
    end

    def text(input_filename, output_filename)
      require 'anon/text'

      abort "No filename specified" if input_filename.nil? || output_filename.nil?

      Anon::Text.anonymise!(input_filename, output_filename)
    end

    def csv(input_filename, output_filename, columns, show_header='')
      require 'anon/csv'

      abort "No filename specified" if input_filename.nil? || output_filename.nil?
      abort "No columns specified" if columns.nil?
      column_array = columns.split(',').map(&:to_i) || abort("Columns should be specified as 1,2,3")

      show_header = (show_header != 'noheader')
      Anon::Csv.anonymise!(input_filename, output_filename, column_array, show_header)
    end

    def help
      puts "Anonymises files.
anon [text|csv] INFILE OUTFILE [options]

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
end