require 'anon/cli'
require 'anon/csv'

describe Anon::CLI do
  describe '.csv' do

    let(:input_filename) { 'spec/fixture/csv_with_headers.csv' }
    let(:output_filename) { 'output' }
    let(:columns) { '1,2,3' }
    let(:has_header) { double }

    subject { described_class.csv(input_filename, output_filename, columns, has_header) }

    context 'without an input filename' do
      let(:input_filename) { nil }

      it 'aborts with a message' do
        expect { subject }.to raise_error SystemExit, "No filename specified"
      end
    end

    context 'with an non existent input file' do
      let(:input_filename) { 'notarealfile' }

      it 'aborts with a message' do
        expect { subject }.to raise_error SystemExit, /No such file or directory/
      end
    end

    context 'on an IO error' do
      before do
        allow(File).to receive(:open).and_raise IOError, 'the IO is broken today, the cat must have gotten in again'
      end

      it 'aborts with a message' do
        expect { subject }.to raise_error SystemExit, 'the IO is broken today, the cat must have gotten in again'
      end
    end

    context 'without an output filename' do
      let(:output_filename) { nil }

      it 'aborts with a message' do
        expect { subject }.to raise_error SystemExit, "No filename specified"
      end
    end

    context 'without columns specified' do
      let(:columns) { nil }

      it 'aborts with a message' do
        expect { subject }.to raise_error SystemExit, "No columns specified"
      end
    end

    context 'when everything is present and correct' do
      it 'invokes the CSV anonymiser' do
        expect(Anon::CSV).to receive(:anonymise!) do |input, output, columns, has_header|
          expect(input.path).to eq input_filename
          expect(output.path).to eq output_filename
          expect(columns).to eq columns
          expect(has_header).to eq has_header
        end
        subject
      end
    end
  end
end
