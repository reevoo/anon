require 'anon/base'

module Anon
  class CSV < Base
    class Columns
      def initialize(columns, headers)
        @columns, @headers = columns, headers
      end

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
