require_relative '../../lib/posting_time'
require_relative '../../lib/config'

RSpec.describe PostingTime do
  subject(:posting_time) {
    described_class.new(
      config: config,
      now: now,
    )
  }

  describe '#next' do
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
    let(:time_zone) { 'US/Eastern' }
    let(:active_weekdays) { [1, 2, 3, 4, 5] }
    let(:start_time) { 9.hours }
    let(:period_length) { 1.hour }
    let(:end_of_day) { 18.hours }

    matcher :match_time do |expected|
      match { |actual|
        (actual.to_i - expected.to_i).abs < 1
      }
      failure_message { |actual|
        "the times do not match"
      }
      diffable
    end

    context 'on an active weekday' do
      context 'before the beginning of the day' do
        let(:now) { Time.utc(2017, 2, 1, 10, 44, 0) } # Wed 05:44 EST
        it 'returns the start time on the same day' do
          expect(posting_time.next).to match_time(Time.utc(2017, 2, 1, 14)) # Wed 09:00 EST
        end
      end
      context 'in the middle of the day' do
        let(:now) { Time.utc(2017, 2, 1, 15, 44, 0) } # Wed 10:44 EST
        it 'returns the next post time on the same day' do
          expect(posting_time.next).to match_time(Time.utc(2017, 2, 1, 16)) # Wed 11:00 EST
        end
      end
      context 'after the end of the active posting time' do
        context 'in the middle of the week' do
          let(:now) { Time.utc(2017, 2, 1, 23, 44, 0) } # Wed 18:44 EST
          it 'returns the start time tomorrow' do
            expect(posting_time.next).to match_time(Time.utc(2017, 2, 2, 14)) # Thu 09:00 EST
          end
        end
        context 'at the end of the week' do
          let(:now) { Time.utc(2017, 2, 3, 23, 44, 0) } # Fri 18:44 EST
          it 'returns the start time on the next active weekday' do
            expect(posting_time.next).to match_time(Time.utc(2017, 2, 6, 14)) # Mon 09:00 EST
          end
          context 'when the next week is DST' do
            let(:now) { Time.utc(2017, 3, 10, 23, 44, 0) } # Fri 18:44 EST
            it 'returns the start time on the next active weekday' do
              expect(posting_time.next).to match_time(Time.utc(2017, 3, 13, 13)) # Mon 09:00 EDT
            end
          end
        end
      end
    end
    context 'on an unactive weekday' do
      context 'context' do
        context 'before the beginning of the day' do
          let(:now) { Time.utc(2017, 1, 29, 10, 44, 0) } # Sun 05:44 EST
          it 'returns the start time on the next active weekday' do
            expect(posting_time.next).to match_time(Time.utc(2017, 1, 30, 14)) # Mon 09:00 EST
          end
        end
        context 'in the middle of the day' do
          let(:now) { Time.utc(2017, 1, 29, 15, 44, 0) } # Sun 10:44 EST
          it 'returns the start time on the next active weekday' do
            expect(posting_time.next).to match_time(Time.utc(2017, 1, 30, 14)) # Mon 09:00 EST
          end
        end
        context 'after the end of the active posting time' do
          context 'at the start of the week' do
            let(:now) { Time.utc(2017, 1, 29, 23, 44, 0) } # Sun 18:44 EST
            it 'returns the start time on the next active weekday' do
              expect(posting_time.next).to match_time(Time.utc(2017, 1, 30, 14)) # Mon 09:00 EST
            end
          end
          context 'at the end of the week' do
            let(:now) { Time.utc(2017, 2, 4, 23, 44, 0) } # Sat 18:44 EST
            it 'returns the start time on the next active weekday' do
              expect(posting_time.next).to match_time(Time.utc(2017, 2, 6, 14)) # Mon 09:00 EST
            end
            context 'when the next week is DST' do
              let(:now) { Time.utc(2017, 3, 10, 23, 44, 0) } # Fri 18:44 EST
              it 'returns the start time on the next active weekday' do
                expect(posting_time.next).to match_time(Time.utc(2017, 3, 13, 13)) # Mon 09:00 EDT
              end
            end
          end
        end
      end
    end
  end
end
