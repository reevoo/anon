require 'spec_helper'

require 'anon/cli'
require 'anon/csv'
require 'anon/text'

describe Anon::CLI do
  describe '#text' do
    context 'without options' do
      it 'calls the text anonomiser with standard in and out' do
        expect(Anon::Text).to receive(:anonymise!).with($stdin, $stdout)
        subject.text
      end
    end

    context 'specifying an input file' do
      it 'calls the text anonomiser with the file' do
        expect(Anon::Text).to receive(:anonymise!) do |input, _output|
          expect(input).to be_a File
          expect(input.path).to eq 'spec/fixture/test.in'
        end
        subject.options = { infile: 'spec/fixture/test.in' }
        subject.text
      end
    end

    context 'specifying an output file' do
      it 'calls the text anonomiser with the file' do
        expect(Anon::Text).to receive(:anonymise!) do |input, _output|
          expect(input).to be_a File
          expect(input.path).to eq 'spec/fixture/test.in'
        end
        subject.options = { infile: 'spec/fixture/test.in' }
        subject.text
      end
    end
  end

  describe '#csv' do
    it 'calls the csv anonomiser with the correct columns' do
      expect(Anon::CSV).to receive(:anonymise!).with($stdin, $stdout, [1, 4, 7], nil)
      subject.options = { columns: '1,4,7' }
      subject.csv
    end
  end
end
