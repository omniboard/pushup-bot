require_relative '../../lib/config'

RSpec.describe Config do
  before do
    ENV['ACTIVE_WEEKDAYS'] = active_weekdays
    ENV['START_TIME'] = start_time
    ENV['PERIOD_MINUTES'] = period_minutes
    ENV['END_TIME'] = end_time
    ENV['SLACK_CHANNEL'] = slack_channel
    ENV['SLACK_API_TOKEN'] = slack_api_token
  end
  after do
    ENV.delete 'ACTIVE_WEEKDAYS'
    ENV.delete 'START_TIME'
    ENV.delete 'PERIOD_MINUTES'
    ENV.delete 'END_TIME'
    ENV.delete 'SLACK_CHANNEL'
    ENV.delete 'SLACK_API_TOKEN'
  end
  let(:active_weekdays) { "MTWRF" }
  let(:start_time) { "09:00 US/Eastern" }
  let(:period_minutes) { "60" }
  let(:end_time) { "18:00" }
  let(:slack_channel) { "slack_channel" }
  let(:slack_api_token) { "slack_api_token" }

  describe '#time_zone' do
    context 'when START_TIME has a valid time zone' do
      it 'returns a time zone object' do
        expect(subject.time_zone.utc_offset).to eq(-5.hours)
      end
    end
    context 'when START_TIME has an invalid time zone' do
      let(:start_time) { "09:00 NotARealPlace" }
      it 'raises a ConfigError' do
        expect { subject.time_zone }.to raise_error(ConfigError)
      end
    end
    context 'when START_TIME is completely invalid' do
      let(:start_time) { "gibberish" }
      it 'raises a ConfigError' do
        expect { subject.time_zone }.to raise_error(ConfigError)
      end
    end
  end

  describe '#period_length_in_seconds' do
    context 'when PERIOD_MINUTES is 60' do
      it 'returns the period length in seconds' do
        expect(subject.period_length_in_seconds).to eq(60.minutes)
      end
    end
    context 'when PERIOD_MINUTES is 45' do
      let(:period_minutes) { "45" }
      it 'returns the period length in seconds' do
        expect(subject.period_length_in_seconds).to eq(45.minutes)
      end
    end
    context 'when PERIOD_MINUTES is not a valid number' do
      let(:period_minutes) { "porcupine sausage" }
      it 'raises a ConfigError' do
        expect { subject.period_length_in_seconds }.to raise_error(ConfigError)
      end
    end
  end

  describe '#active_weekdays' do
    context 'when ACTIVE_WEEKDAYS contains valid weekday letters (UMTRFS) in any order' do
      it 'returns an array of weekday integers (0 == Sunday)' do
        expect(subject.active_weekdays).to eq([1, 2, 3, 4, 5])
      end
    end
    context 'when ACTIVE_WEEKDAYS contains invalid weekday letters' do
      let(:active_weekdays) { "MTI" }
      it 'raises a ConfigError' do
        expect { subject.active_weekdays }.to raise_error(ConfigError)
      end
    end
  end

  describe '#start_time_in_seconds' do
    context 'when START_TIME contains a valid time' do
      it 'returns the time as the number of seconds after midnight' do
        expect(subject.start_time_in_seconds).to eq(9.hours)
      end
    end
    context 'when START_TIME is completely invalid' do
      let(:start_time) { "gibberish" }
      it 'raises a ConfigError' do
        expect { subject.start_time_in_seconds }.to raise_error(ConfigError)
      end
    end
  end

  describe '#end_of_day_in_seconds' do
    context 'when END_TIME contains a valid time' do
      it 'returns the time as the number of seconds after midnight' do
        expect(subject.end_of_day_in_seconds).to eq(18.hours)
      end
    end
    context 'when END_TIME is not after START_TIME' do
      let(:end_time) { "09:00" }
      it 'raises a ConfigError' do
        expect { subject.end_of_day_in_seconds }.to raise_error(ConfigError)
      end
    end
    context 'when END_TIME is completely invalid' do
      let(:end_time) { "gibberish" }
      it 'raises a ConfigError' do
        expect { subject.end_of_day_in_seconds }.to raise_error(ConfigError)
      end
    end
  end

  describe '#slack_api_token' do
    context 'when SLACK_API_TOKEN is set' do
      it 'returns the contents of it' do
        expect(subject.slack_api_token).to eq(slack_api_token)
      end
    end
    context 'when SLACK_API_TOKEN is not set' do
      before do
        ENV.delete 'SLACK_API_TOKEN'
      end
      it 'raises a ConfigError' do
        expect { subject.slack_api_token }.to raise_error(ConfigError)
      end
    end
  end

  describe '#slack_channel' do
    context 'when SLACK_CHANNEL is set' do
      it 'returns the contents of it' do
        expect(subject.slack_channel).to eq(slack_channel)
      end
    end
    context 'when SLACK_CHANNEL is not set' do
      before do
        ENV.delete 'SLACK_CHANNEL'
      end
      it 'raises a ConfigError' do
        expect { subject.slack_channel }.to raise_error(ConfigError)
      end
    end
  end
end
