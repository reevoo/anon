require 'spec_helper'
require 'anon/cli'
require 'anon/csv'
require 'anon/text'

describe Anon::CLI do
  describe '.parse!' do
    context 'with an unkown command' do
      it 'returns the help message' do
        expect(described_class).to receive(:help)
        described_class.parse! ['jelly', 'and', 'ice', 'cream']
      end
    end

    context 'with a real command' do
      it 'calls the correct command' do
        expect(described_class).to receive(:text).with('in', 'out')
        described_class.parse! ['text', 'in', 'out']
      end
    end
  end

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

  describe 'text' do
    let(:input_filename) { 'spec/fixture/csv_with_headers.csv' }
    let(:output_filename) { 'output' }

    subject { described_class.text(input_filename, output_filename) }

    context 'without an input filename' do
      let(:input_filename) { nil }

      it 'aborts with a message' do
        expect { subject }.to raise_error SystemExit, "No filename specified"
      end
    end

    context 'without an output filename' do
      let(:output_filename) { nil }

      it 'aborts with a message' do
        expect { subject }.to raise_error SystemExit, "No filename specified"
      end
    end


    context 'when everything is present and correct' do
      it 'invokes the Text anonymiser' do
        expect(Anon::Text).to receive(:anonymise!) do |input, output|
          expect(input.path).to eq input_filename
          expect(output.path).to eq output_filename
        end
        subject
      end
    end
  end

  describe '.help' do
    it 'outputs some help text' do
      expect(capture_stdout { described_class.help }).to include 'anon'
    end
  end
end
