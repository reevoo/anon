module Anon
  # Command Line Interface for Anon
  module CLI

    # Parse the command and execute the desired command
    def self.parse!(args)
      command, infile, outfile, *command_args = args

      return help if command.nil? || !respond_to?(command.to_sym)
      abort 'No filename specified' if [infile, outfile].any?(&:nil?)

      input = File.open(infile)
      output = File.open(outfile, 'w')

      send(command, input, output, *command_args)
    rescue Errno::ENOENT, IOError => e
      abort e.message
    end

    def self.text(input, output)
      require 'anon/text'
      Anon::Text.anonymise!(input, output)
    end

    def self.csv(input, output, columns = nil, show_header = '')
      require 'anon/csv'

      abort 'No columns specified' if columns.nil?
      column_array = columns.split(',').map(&:to_i) || abort('Columns should be specified as 1,2,3')
      show_header = (show_header != 'noheader')

      Anon::CSV.anonymise!(input, output, column_array, show_header)
    end

    HELPTEXT = "Anonymises files.
anon [text|csv] INFILE OUTFILE [options]

There are two types of processing:
  text - anonymise any valid e-mail address in the text:
  csv  - anonymise the content of a specific column in a CSV

To anonymise any e-mail address in a file, use:
  anon text in.txt out.txt

For CSV, you must specify the columns to anonymise, for example:
  anon csv in.csv out.csv 0,2,5
Note that the first column is column 0 when numbering columns.

You can also specify the noheader option if the CSV has no header:
  ruby anon.rb csv in.csv out.csv 1 noheader"

    def self.help
      puts HELPTEXT
    end
  end
end
