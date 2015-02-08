# encoding: utf-8

require 'time_difference'

module Anon
  # Anonymiser base class
  class Base

    # Performs anonymisation
    def self.anonymise!(*args)
      new(*args).anonymise!
    end

    protected

    # Helper method that replaces a personal e-mail
    # with an anonymous one.
    #
    # The same personal e-mail will be replaced
    # with the same anonymous e-mail.
    def anonymous_email(personal_email)
      @anonymised_emails ||= {}

      unless @anonymised_emails.key? personal_email
        next_count = @anonymised_emails.count + 1
        @anonymised_emails[personal_email] = "anon#{next_count}@anon.com"
      end

      @anonymised_emails[personal_email]
    end

    # Initializes progress tracking.
    def start_progress
      @progress = 0
      @started = Time.now
      update_progress
    end

    # Adds 1 to the progress count.
    def increment_progress
      @progress += 1
      update_progress
    end

    # End progress tracking and output the results.
    def complete_progress
      stopped = Time.now
      duration = TimeDifference.between(@started, stopped).in_seconds
      if duration == 0
        average = @progress
      else
        average = (@progress.to_f / duration.to_f).round
      end

      $stderr.puts "Read #{@progress} lines in #{duration} seconds (#{average} lines/s)"
      $stderr.puts "#{@anonymised_emails.count} unique e-mails replaced"
    end

    private

    def update_progress
      output_progress if @progress % 100 == 0
    end

    def output_progress
      print "Working... #{@progress}\r"
      $stdout.flush
    end
  end
end
