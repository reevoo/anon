require 'spec_helper'
require 'fileutils'

describe 'The comand line interface' do
  let(:expected_output) do
    'pgid_sku,contract start date,e---mail,post_code,product_category,transmission_type
F^u4bgebdfds, 15/07/1756,anon1@anon.com, XY1 TH7, jokes > joke books, oily
FNY7dujh, 15/11/1856,anon2@anon.com, CZ1 NJ7, books > dusty, automatic
'
  end

  describe 'text' do

    describe 'reading from a file' do
      let(:output) { `bin/anon text -i spec/fixture/csv_with_headers.csv` }
      specify { expect(output).to eq expected_output }
    end

    describe 'reading from stdin' do
      let(:output) { `cat spec/fixture/csv_with_headers.csv | bin/anon text` }
      specify { expect(output).to eq expected_output }
    end

    describe 'writing to a file' do
      let(:output) do
        FileUtils.rm_rf('spec/fixture/test.out')
        `cat spec/fixture/csv_with_headers.csv | bin/anon text -o spec/fixture/test.out`
        File.read('spec/fixture/test.out')
      end
      specify { expect(output).to eq expected_output }
    end

  end

  describe 'csv' do
    describe 'reading from a file' do
      let(:output) { `bin/anon csv -i spec/fixture/csv_with_headers.csv -c 2` }
      specify { expect(output).to eq expected_output }
    end

    describe 'reading from stdin' do
      let(:output) { `cat spec/fixture/csv_with_headers.csv | bin/anon csv -c 2` }
      specify { expect(output).to eq expected_output }
    end

    describe 'writing to a file' do
      let(:output) do
        FileUtils.rm_rf('spec/fixture/test.out')
        `cat spec/fixture/csv_with_headers.csv | bin/anon csv -c 2 -o spec/fixture/test.out`
        File.read('spec/fixture/test.out')
      end
      specify { expect(output).to eq expected_output }
    end

    describe 'a headerless file' do
      let(:expected_output) do
        'F^u4bgebdfds, 15/07/1756,anon1@anon.com, XY1 TH7, jokes > joke books, oily
FNY7dujh, 15/11/1856,anon2@anon.com, CZ1 NJ7, books > dusty, automatic
'
      end

      let(:output) { `bin/anon csv -c 2 -i spec/fixture/csv_without_headers.csv --no-header` }
      specify { expect(output).to eq expected_output }
    end

    describe 'named headers' do
      let(:output) { `bin/anon csv -i spec/fixture/csv_with_headers.csv -c e---mail` }
      specify { expect(output).to eq expected_output }
    end

    describe 'automatic header detection' do
      let(:output) { `bin/anon csv -i spec/fixture/csv_with_headers.csv` }
      specify { expect(output).to eq expected_output }
    end
  end
end
