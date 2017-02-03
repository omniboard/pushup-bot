require_relative '../../lib/slack_interactor'

RSpec.describe SlackInteractor do
  subject(:slack_interactor) { described_class.new(config: config) }
  before do
    allow(Slack::Web::Client).to receive(:new).and_return(slack_client)
  end
  let(:slack_client) { instance_double(Slack::Web::Client) }
  let(:config) {
    instance_double(
      Config,
      slack_api_token: slack_api_token,
      slack_channel: slack_channel,
    )
  }
  let(:slack_api_token) { "slack_api_token" }
  let(:slack_channel) { "slack_channel" }

  describe '#pushup_time' do
    it "sends a Slack message that it's time to do pushups" do
      expect(slack_client).to receive(:chat_postMessage).with(hash_including(
        channel: "\##{slack_channel}",
        text: /time for pushups!/,
      ))
      slack_interactor.pushup_time
    end
  end

  describe '#next_pushup_time' do
    it "sends a Slack message that it's time to do pushups" do
      expect(slack_client).to receive(:chat_postMessage).with(hash_including(
        channel: "\##{slack_channel}",
        text: /next pushups in 10 minutes/i,
      ))
      slack_interactor.next_pushup_time(10.minutes.from_now)
    end
  end
end
