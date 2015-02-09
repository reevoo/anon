require 'spec_helper'
require 'anon/text'

describe Anon::Text do
  let(:output_stream) { StringIO.new }
  subject { described_class.new(input_stream, output_stream) }

  describe '#anonymise!' do
    let(:input_stream) do
      StringIO.new ' someone@foo.com then some other interesting text another@icecream.museum'
    end

    it 'anonymises any email addresss' do
      subject.anonymise!
      expect(output_stream.string).to_not include 'someone@foo.com'
      expect(output_stream.string).to_not include 'another@icecream.museum'
    end

    it 'leaves the other text alone' do
      subject.anonymise!
      expect(output_stream.string).to eq " anon1@anon.com then some other interesting text anon2@anon.com\n"
    end
  end
end
