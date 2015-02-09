require 'spec_helper'
require 'anon/cli'
require 'anon/csv'
require 'anon/text'

describe Anon::CLI do
  describe '.parse!' do
    context 'with an unkown command' do
      it 'returns the help message' do
        expect(described_class).to receive(:help)
        described_class.parse! %w(jelly and ice cream)
      end
    end

    context 'with a real command' do
      it 'calls the correct command' do
        expect(described_class).to receive(:text) do |input, output|
          expect(input.path).to eq 'spec/fixture/test.in'
          expect(output.path).to eq 'spec/fixture/test.out'
        end
        described_class.parse! %w(text spec/fixture/test.in spec/fixture/test.out)
      end

      context 'without an input filename' do
        let(:input_filename) { nil }

        it 'aborts with a message' do
          expect do
            described_class.parse! %w(text)
          end.to raise_error SystemExit, 'No filename specified'
        end
      end

      context 'without an output filename' do
        let(:input_filename) { nil }

        it 'aborts with a message' do
          expect do
            described_class.parse! %w(text spec/fixture/test.in)
          end.to raise_error SystemExit, 'No filename specified'
        end
      end

      context 'on an IO error' do
        before do
          allow(File).to receive(:open).and_raise IOError, 'the IO is broken today, the cat must have gotten in again'
        end

        it 'aborts with a message' do
          expect do
            described_class.parse! %w(text spec/fixture/test.in spec/fixture/test.out)
          end.to raise_error SystemExit, 'the IO is broken today, the cat must have gotten in again'
        end
      end

      context 'if the input file does not exist' do
        it 'aborts with a message' do
          expect do
            described_class.parse! %w(text notarealfilename spec/fixture/test.out)
          end.to raise_error SystemExit, /No such file or directory/
        end
      end

      describe 'the csv command' do
        let(:input_filename) { 'spec/fixture/csv_with_headers.csv' }
        let(:output_filename) { 'spec/fixture/test.out' }
        let(:columns) { '1,2,3' }
        let(:has_header) { double }

        it 'invokes the csv anonymiser' do
          expect(Anon::CSV).to receive(:anonymise!) do |input, output, columns, has_header|
            expect(input.path).to eq input_filename
            expect(output.path).to eq output_filename
            expect(columns).to eq columns
            expect(has_header).to eq has_header
          end

          described_class.parse! ['csv', input_filename, output_filename, columns, has_header]
        end

        context 'if the collums are not specified' do
          it 'aborts with an error' do
            expect do
              described_class.parse! ['csv', input_filename, output_filename]
            end.to raise_error SystemExit, 'No columns specified'
          end
        end
      end

      describe 'the text command' do
        let(:input_filename) { 'spec/fixture/test.in' }
        let(:output_filename) { 'spec/fixture/test.out' }

        it 'invokes the Text anonymiser' do
          expect(Anon::Text).to receive(:anonymise!) do |input, output|
            expect(input.path).to eq input_filename
            expect(output.path).to eq output_filename
          end
          described_class.parse! ['text', input_filename, output_filename]
        end
      end
    end
  end

  describe '.help' do
    it 'outputs some help text' do
      expect(capture_stdout { described_class.help }).to include 'anon'
    end
  end
end
