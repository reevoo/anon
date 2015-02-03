# encoding: utf-8

module Anon
  # Anonymiser base class
  class Base

    def self.anonymise!(*args)
      new(*args).anonymise!
    end

    protected

    def anonymous_email(personal_email)
      @anonymised_emails ||= {}
      
      unless @anonymised_emails.has_key? personal_email
        next_count = @anonymised_emails.count + 1
        @anonymised_emails[personal_email] = "anon#{next_count}@reevoo.com"
      end

      @anonymised_emails[personal_email]     
    end

    def start_progress
      @progress = 0
      @started = Time.now
      update_progress
    end

    def increment_progress
      @progress += 1
      update_progress
    end

    def complete_progress
      stopped = Time.now
      duration = TimeDifference.between(@started, stopped).in_seconds
      average = (@progress.to_f / duration.to_f).round
      puts "Read #{@progress} lines in #{duration} seconds (#{average} lines/s)"
      puts "#{@anonymised_emails.count} unique e-mails replaced"
    end

    private

    def update_progress
      if @progress % 100 == 0
        print "Working... #{@progress}\r"
        $stdout.flush
      end
    end
  end
end
