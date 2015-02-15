require 'spec_helper'
require 'anon/base'

describe Anon::Base do
  subject { SlowOne.new }

  describe '#anonymise!' do
    it 'writes some info about the time taken and number of emails to stderr' do
      output = capture_stderr do
        subject.anonymise!
      end
      expect(output).to include '1.0 seconds'
      expect(output).to include '1 unique e-mails replaced'
    end
  end
end

class SlowOne < Anon::Base
  def anonymise!
    start_progress
    anonymous_email('foo@bar.com')
    sleep 1
    complete_progress
  end
end
