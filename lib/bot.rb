require_relative 'posting_time'

class Bot
  def initialize(config:, chat_bot:)
    self.config = config
    self.chat_bot = chat_bot
  end

  def run
    next_post_time = report_and_determine_next_post_time
    loop do
      sleep(next_post_time - Time.now)
      chat_bot.pushup_time
      next_post_time = report_and_determine_next_post_time
    end
  end

  private

  attr_accessor :config
  attr_accessor :chat_bot

  def report_and_determine_next_post_time
    next_posting_time.tap do |next_time|
      chat_bot.next_pushup_time(next_time)
    end
  end

  def next_posting_time
    PostingTime.new(config: config, now: Time.now).next
  end
end
