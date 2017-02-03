##
# Sends messages to Slack.
class SlackInteractor
  def initialize(config:)
    self.config = config
    api_token
    channel
  end

  def send(message)
    client.chat_postMessage(channel: "\##{channel}", text: message, as_user: true)
  end

  def pushup_time
    send("<!channel> time for pushups!")
  end

  def next_pushup_time(next_time)
    minutes_from_now = ((next_time - Time.now) / 1.minute).ceil
    send("Next pushups in #{minutes_from_now} minutes.")
  end

  private

  attr_accessor :config

  def client
    @client ||= Slack::Web::Client.new(token: api_token, user_agent: 'PushupBot')
  end

  def api_token
    config.slack_api_token
  end

  def channel
    config.slack_channel
  end
end
