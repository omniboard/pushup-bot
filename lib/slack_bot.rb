class SlackBot
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

  def client
    @client ||= Slack::Web::Client.new(token: slack_api_token, user_agent: 'PushupBot')
  end

  def slack_api_token
    ConfigVariable.new(name: 'SLACK_API_TOKEN').value
  end

  def channel
    ConfigVariable.new(name: 'SLACK_CHANNEL').value
  end
end
