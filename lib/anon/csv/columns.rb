require 'anon/base'

module Anon
  class CSV < Base
    # Encapsulates the logic required to choose and format the list
    # of columns to be anonomised
    class Columns
      # Initialzes a new instance of Columns
      # @param columns [String] the columns to be anonomised, comma seperated may be names or indexes
      # @param headers [Array<String>] the full list of headers
      def initialize(columns, headers)
        @columns, @headers = columns, headers
      end

      # Returns the columns that should be anonomised, if the object was initialized without a
      # predefined list of columns then returns a guess based on the list of headers.
      # @return [Array<String,Integer>] the columns to be anonomised, indexes are returned as Integer
      def to_anonymise
        @_to_anonymise ||= indexes || columns || best_guess
      end

      private

      attr_reader :headers

      def indexes
        columns.map { |c| Integer(c) } if columns
      rescue ArgumentError
        nil
      end

      def columns
        @columns.split(',') if @columns
      end

      def best_guess
        headers.select { |h| h.match(/e.*mail/i) }
      end
    end
  end
end
