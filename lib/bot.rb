require_relative 'posting_time'

##
# Performs the main behavior of the project. Waits until the next posting time, posts the message,
# then waits until next time.
class Bot
  def initialize(config:, interactor:)
    self.config = config
    self.interactor = interactor
  end

  def run
    next_post_time = report_and_determine_next_post_time
    loop do
      sleep(next_post_time - Time.now)
      interactor.pushup_time
      next_post_time = report_and_determine_next_post_time
    end
  end

  private

  attr_accessor :config
  attr_accessor :interactor

  def report_and_determine_next_post_time
    next_posting_time.tap do |next_time|
      interactor.next_pushup_time(next_time)
    end
  end

  def next_posting_time
    PostingTime.new(config: config, now: Time.now).next
  end
end
