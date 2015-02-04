require 'anon/cli'
require 'anon/csv'

describe Anon::CLI do
  describe '.csv' do

    let(:input_filename) { double }
    let(:output_filename) { double }
    let(:columns) { '1,2,3' }
    let(:show_header) { double }

    subject { described_class.csv(input_filename, output_filename, columns, show_header) }

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

    context 'without columns specified' do
      let(:columns) { nil }

      it 'aborts with a message' do
        expect { subject }.to raise_error SystemExit, "No columns specified"
      end
    end

    context 'when everything is present and correct' do
      it 'invokes the CSV anonymiser' do
        expect(Anon::CSV).to receive(:anonymise!)
        subject
      end
    end
  end
end
