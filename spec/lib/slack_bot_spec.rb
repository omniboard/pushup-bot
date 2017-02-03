require_relative '../../lib/slack_bot'

RSpec.describe SlackBot do
  subject(:slack_bot) { described_class.new }
  before do
    allow(Slack::Web::Client).to receive(:new).and_return(slack_client)
  end
  let(:slack_client) { instance_double(Slack::Web::Client) }
  let(:slack_api_token) { "slack_api_token" }
  let(:slack_channel) { "slack_channel" }

  shared_context 'Slack fully configured' do
    before do
      ENV['SLACK_CHANNEL'] = slack_channel
      ENV['SLACK_API_TOKEN'] = slack_api_token
    end
    after do
      ENV.delete 'SLACK_CHANNEL'
      ENV.delete 'SLACK_API_TOKEN'
    end
  end

  describe '#initialize' do
    context 'when SLACK_API_TOKEN is not configured' do
      before do
        ENV['SLACK_CHANNEL'] = slack_channel
      end
      after do
        ENV.delete 'SLACK_CHANNEL'
      end
      it 'raises a ConfigError' do
        expect { slack_bot }.to raise_error(ConfigError)
      end
    end
    context 'when SLACK_CHANNEL is not configured' do
      before do
        ENV['SLACK_API_TOKEN'] = slack_api_token
      end
      after do
        ENV.delete 'SLACK_API_TOKEN'
      end
      it 'raises a ConfigError' do
        expect { slack_bot }.to raise_error(ConfigError)
      end
    end
    context 'when configured' do
      include_context 'Slack fully configured'
      it 'does not raise a ConfigError' do
        expect { slack_bot }.to_not raise_error
      end
    end
  end

  context 'when configured' do
    include_context 'Slack fully configured'

    describe '#pushup_time' do
      it "sends a Slack message that it's time to do pushups" do
        expect(slack_client).to receive(:chat_postMessage).with(hash_including(
          channel: "\##{slack_channel}",
          text: %r{time for pushups!},
        ))
        slack_bot.pushup_time
      end
    end

    describe '#next_pushup_time' do
      it "sends a Slack message that it's time to do pushups" do
        expect(slack_client).to receive(:chat_postMessage).with(hash_including(
          channel: "\##{slack_channel}",
          text: /next pushups in 10 minutes/i,
        ))
        slack_bot.next_pushup_time(10.minutes.from_now)
      end
    end
  end
end
