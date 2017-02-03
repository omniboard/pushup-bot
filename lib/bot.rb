require_relative 'posting_time'

class Bot
  def initialize(config:, chat_bot:)
    self.config = config
    self.chat_bot = chat_bot
  end

  def run
    next_time = get_next_posting_time
    loop do
      sleep(next_time - Time.now)
      chat_bot.pushup_time
      next_time = get_next_posting_time
    end
  end

  private

  attr_accessor :config
  attr_accessor :chat_bot

  def get_next_posting_time
    next_posting_time.tap do |next_time|
      chat_bot.next_pushup_time(next_time)
    end
  end

  def next_posting_time
    PostingTime.new(config: config, now: Time.now).next
  end
end
