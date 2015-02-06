module Anon
  # Command Line Interface for Anon
  module CLI

    # Parse the command and execute the desired command
    def self.parse!(args)
      # Direct command to methods of this module
      command, *command_args = args
      if (!command.nil?) && respond_to?(command.to_sym)
        send(command, *command_args)
      else
        help
      end
    end

    # Anonymise all e-mails found in given text
    def self.text(input_filename=nil, output_filename=nil)
      require 'anon/text'

      abort 'No filename specified' if input_filename.nil? || output_filename.nil?

      input = File.open(input_filename)
      output = File.open(output_filename, 'w')
      Anon::Text.anonymise!(input, output)
    end

    # Anonymise all contents of the given CSV columns
    def self.csv(input_filename=nil, output_filename=nil, columns=nil, show_header='')
      require 'anon/csv'

      abort 'No filename specified' if input_filename.nil? || output_filename.nil?
      abort 'No columns specified' if columns.nil?
      column_array = columns.split(',').map(&:to_i) || abort('Columns should be specified as 1,2,3')

      show_header = (show_header != 'noheader')

      input = File.open(input_filename)
      output = File.open(output_filename, 'w')
      Anon::CSV.anonymise!(input, output, column_array, show_header)
    rescue Errno::ENOENT, IOError => e
      abort e.message
    end

    # Output a help message
    def self.help
      puts 'Anonymises files.
anon [text|csv] INFILE OUTFILE [options]

There are two types of processing:
  text - anonymise any valid e-mail address in the text
  csv  - anonymise the content of a specific column in a CSV

To anonymise any e-mail address in a file, use:
  anon text in.txt out.txt

For CSV, you must specify the columns to anonymise, for example:
  anon csv in.csv out.csv 0,2,5
Note that the first column is column 0 when numbering columns.

You can also specify the noheader option if the CSV has no header:
  ruby anon.rb csv in.csv out.csv 1 noheader'
    end
  end
end
