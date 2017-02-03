require_relative '../lib/bot'
require_relative '../lib/slack_interactor'
require_relative '../lib/config'

namespace :bot do
  desc "Connects to Slack and interacts with the channel."
  task :slack do
    config = Config.new
    Bot.new(config: config, interactor: SlackInteractor.new(config)).run
  end
end
