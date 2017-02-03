require_relative '../../lib/bot'

RSpec.describe Bot do
  let(:bot) { described_class.new(config: config, chat_bot: chat_bot) }
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
  let(:chat_bot) { instance_double(SlackBot, pushup_time: nil, next_pushup_time: nil) }

  let(:time_zone) { 'US/Eastern' }
  let(:active_weekdays) { [1, 2, 3, 4, 5] }
  let(:start_time) { 9.hours }
  let(:period_length) { 1.hour }
  let(:end_of_day) { 18.hours }

  describe '#run' do
    before do
      @loop_count = 0
      allow(bot).to receive(:sleep) do
        @loop_count += 1
        throw :done if @loop_count > 1
      end

      allow(PostingTime).to receive(:new).and_return(posting_time)
      allow(posting_time).to receive(:next).and_return(five_minutes_from_now, ten_more_minutes)
    end
    let(:posting_time) { instance_double(PostingTime, next: next_posting_time) }
    let(:next_posting_time) { Time.utc(2017, 3, 1, 12, 0) }
    let(:right_now) { Time.utc(2017, 2, 1, 10, 44, 0) }
    let(:five_minutes_from_now) { Time.utc(2017, 2, 1, 10, 49) }
    let(:ten_more_minutes) { Time.utc(2017, 2, 1, 10, 59) }

    context 'while looping forever' do
      it 'informs the chatbot of the time of the first post' do
        Timecop.freeze(right_now) do
          catch :done do
            expect(chat_bot).to receive(:next_pushup_time).with(five_minutes_from_now)
            bot.run
          end
        end
      end
      it 'sleeps until the next post time' do
        Timecop.freeze(right_now) do
          catch :done do
            expect(bot).to receive(:sleep).with(5.minutes.to_i)
            bot.run
          end
        end
      end
      it 'sends a message with the pushup message' do
        Timecop.freeze(right_now) do
          catch :done do
            expect(chat_bot).to receive(:pushup_time)
            bot.run
          end
        end
      end
      it 'informs the chatbot of the time of the next post' do
        Timecop.freeze(right_now) do
          catch :done do
            bot.run
          end
          expect(chat_bot).to have_received(:next_pushup_time).with(ten_more_minutes)
        end
      end
      it 'and it does it all in the right order' do
        Timecop.freeze(right_now) do
          catch :done do
            expect(chat_bot).to receive(:next_pushup_time).with(five_minutes_from_now).ordered
            expect(bot).to receive(:sleep).with(5.minutes.to_i).ordered
            expect(chat_bot).to receive(:pushup_time).ordered
            expect(chat_bot).to receive(:next_pushup_time).with(ten_more_minutes).ordered
            bot.run
          end
        end
      end
    end
  end
end
