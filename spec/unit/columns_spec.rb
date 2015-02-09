require 'spec_helper'
require 'anon/csv/columns'

describe Anon::CSV::Columns do
  describe '#to_anonymise' do
    context 'index columns' do
      subject { described_class.new('1,2,3', double) }

      it 'converts the indexes to Integers' do
        expect(subject.to_anonymise).to eq [1, 2, 3]
      end
    end

    context 'named columns' do
      subject { described_class.new('email_address,name,foo', double) }

      it 'returns the named columns' do
        expect(subject.to_anonymise).to eq %w(email_address name foo)
      end
    end

    context 'automatic column detection' do
      let(:email_headers) do
        [
          'email',
          'zemailaddress',
          'contact email address',
          'emailaddress',
          'e-mail',
          'personal email',
          'email address',
          'ct_email_addr',
          'e_mail_address',
          'student_e_mail',
          'e-mail address',
          'parent email address',
          'customer email address',
          'email_address',
          'contact address.email',
          'user email string',
          'email client',
          'client email',
          'ot ship-to email address',
          'customer email',
          'clnp email address1',
          'default_email',
          'email_addr',
          'sender_email',
          'webemail',
        ]
      end

      let(:non_email_headers) do
        [
          'pgid_sku',
          'contract start date',
          'post_code',
          'product_category',
          'transmission_type',
          'policy_start_date',
          'category-genericname',
          'order id',
          'unique_model',
          'start',
          'image',
          'orderdate',
          'model',
          'homebound date',
          'pid-cid',
          'ct_name_last',
          'booking ref.',
          'a5',
          'id',
          'bazaarvoice id',
          'questionnaire_name',
          'deeplink_id',
          'hotel_name',
          'series_identifier',
          'registration',
          'zmailname',
        ]
      end

      let(:headers) { email_headers + non_email_headers }

      subject { described_class.new(nil, headers.shuffle) }

      it 'returns the email related headers' do
        expect(subject.to_anonymise.sort).to eq email_headers.sort
      end
    end
  end
end
