require_relative '../lib/bot'
require_relative '../lib/slack_bot'
require_relative '../lib/config'

namespace :bot do
  desc "Connects to Slack and interacts with the channel."
  task :slack do
    Bot.new(config: Config.new, chat_bot: SlackBot.new).run
  end
end
