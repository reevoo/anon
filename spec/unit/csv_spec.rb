require 'spec_helper'
require 'anon/csv'

describe Anon::CSV do

  describe '.anonymise!' do

    before do
      described_class.anonymise!(input_stream, output_stream, columns, headers)
    end

    let(:output_stream) { StringIO.new }
    let(:columns) { ['0'] }

    context 'with headers' do
      let(:headers) { true }

      let(:input_stream) do
        StringIO.new "email,foo,bar
        foo@bar.com,34545,bannas
        foopface@fooofoo.co.uk,124353,apples"
      end

      it 'anonymises the correct column' do
        output_stream.rewind
        expect(output_stream.gets).to eq "email,foo,bar\n"
        expect(output_stream.gets).to eq "anon1@anon.com,34545,bannas\n"
        expect(output_stream.gets).to eq "anon2@anon.com,124353,apples\n"
        expect(output_stream.gets).to eq nil
      end

      context 'with named columns' do
        let(:columns) { %w(email bar) }

        it 'anonymises the correct columns' do
          output_stream.rewind
          expect(output_stream.gets).to eq "email,foo,bar\n"
          expect(output_stream.gets).to eq "anon1@anon.com,34545,anon2@anon.com\n"
          expect(output_stream.gets).to eq "anon3@anon.com,124353,anon4@anon.com\n"
          expect(output_stream.gets).to eq nil
        end
      end
    end

    context 'without headers' do
      let(:headers) { false }

      let(:input_stream) do
        StringIO.new "looloo@example.com,2456,satsuma
        foo@bar.com,34545,bannas
        foopface@fooofoo.co.uk,124353,apples"
      end

      it 'anonymises the correct column' do
        output_stream.rewind
        expect(output_stream.gets).to eq "anon1@anon.com,2456,satsuma\n"
        expect(output_stream.gets).to eq "anon2@anon.com,34545,bannas\n"
        expect(output_stream.gets).to eq "anon3@anon.com,124353,apples\n"
        expect(output_stream.gets).to eq nil
      end
    end
  end
end
