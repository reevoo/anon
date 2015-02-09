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
           desc: 'columns to anonymise, by index or name e.g. 0,1,5 or email-address,other_email',
           required: true

    option :header,
           type: :boolean,
           default: true,
           desc: 'if the csv file to be processed has a header row'

    def csv
      require 'anon/csv'
      Anon::CSV.anonymise!(input, output, column_array, options[:header])
    end

    desc 'text [OPTIONS]', 'Anonymise a text file'

    option :infile,
           aliases: [:i],
           desc: 'input filename to read from, reads from STDIN if ommited'

    option :outfile,
           aliases: [:o],
           desc: 'output filename write to, writes to STDOUT if ommited'

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

    def column_array
      options[:columns].split(',')
    end
  end
end
