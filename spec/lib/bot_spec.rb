require_relative '../../lib/bot'

RSpec.describe Bot do
  let(:bot) { described_class.new(config, chat_bot) }
  let(:config) {
    instance_double(
      Config,
      time_zone: ActiveSupport::TimeZone[time_zone],
      active_weekdays: active_weekdays,
      start_time_in_seconds: start_time.to_i,
      period_length_in_seconds: period_length.to_i,
      end_of_day_in_seconds: end_of_day.to_i,
    )
  }
  let(:chat_bot) { instance_double(SlackBot, send: nil) }

  let(:time_zone) { 'US/Eastern' }
  let(:active_weekdays) { [1, 2, 3, 4, 5] }
  let(:start_time) { 9.hours }
  let(:period_length) { 1.hour }
  let(:end_of_day) { 18.hours }

  describe '#run' do
    before do
      allow(bot).to receive(:sleep)
    end

    it 'sends a message with the time of the next post' do
      Timecop.freeze(Time.utc()) do
      expect()
    end
    it 'sleeps until the next post time' do
    end
    it 'sends a message with the pushup message' do
    end
    it 'loops forever' do
    end
  end
end
