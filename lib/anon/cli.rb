require 'thor'

module Anon
  # Command Line Interface for Anon
  class CLI < Thor

    desc 'csv [OPTIONS]', 'Anonymise a csv file'

    option :infile,
           aliases: [:i],
           desc: 'input filename to read from, reads from STDIN if ommited'

    option :outfile,
           aliases: [:o],
           desc: 'output filename write to, writes to STDOUT if ommited'

    option :columns,
           aliases: [:c],
           desc: 'columns to anonymise, by index or name
e.g. 0,1,5 or email-address,other_email, guesses based on header if ommited'

    option :header,
           type: :boolean,
           default: true,
           desc: 'if the csv file to be processed has a header row'

    # The cli command to launch the CSV anonymiser
    # Input and output may be set to filepaths, or default to stdin and out
    # The columns to be anonymised can be set, or we default to a detection stratergy if there is a header row
    # Optionly we can choose to process files without a header row, but then columns must be set
    def csv
      require 'anon/csv'
      Anon::CSV.anonymise!(input, output, options[:columns], options[:header])
    end

    desc 'text [OPTIONS]', 'Anonymise a text file'

    option :infile,
           aliases: [:i],
           desc: 'input filename to read from, reads from STDIN if ommited'

    option :outfile,
           aliases: [:o],
           desc: 'output filename write to, writes to STDOUT if ommited'

    # The cli command to launch the Text anonymiser
    # Input and output may be set to filepaths, or default to stdin and out
    def text
      require 'anon/text'
      Anon::Text.anonymise!(input, output)
    end

    private

    def input
      options[:infile] ? File.open(options[:infile]) : $stdin
    end

    def output
      options[:outfile] ? File.open(options[:outfile], 'w') : $stdout
    end
  end
end
