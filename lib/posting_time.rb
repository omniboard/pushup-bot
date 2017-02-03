require 'active_support'

class PostingTime
  def initialize(config:, now:)
    self.config = config
    self.now = now.in_time_zone(config.time_zone)
  end

  def next
    # binding.pry
    if current_day_active? && !ended_for_today?
      next_notification_today
    else
      next_active_date + start_time_in_seconds.seconds
    end
  end

  private

  attr_accessor :config
  attr_accessor :now

  # An integer representing the day of the week, 0..6, with Sunday == 0.
  def current_weekday
    @current_weekday ||= now.wday
  end

  def current_day_active?
    active_weekdays.include? current_weekday
  end

  # The time today at which no more reminders should be sent. In seconds after midnight.
  def end_of_day_today
    now.in_time_zone(time_zone).beginning_of_day + end_of_day_in_seconds
  end

  # Determines whether it's past the last posting time for today.
  def ended_for_today?
    now >= end_of_day_today
  end

  def next_notification_today
    seconds_since_midnight = (now - now.beginning_of_day).to_i
    if seconds_since_midnight > start_time_in_seconds
      seconds_since_start = seconds_since_midnight - start_time_in_seconds
      now.advance seconds: (period_length_in_seconds - (seconds_since_start % period_length_in_seconds))
    else
      now.beginning_of_day.advance seconds: start_time_in_seconds.seconds
    end
  end

  def next_active_date
    # any days left this week?
    if current_weekday < active_weekdays.max
      next_active_weekday = active_weekdays.sort.find { |wday| wday > current_weekday }
      days_from_now = next_active_weekday - current_weekday
    else
      end_of_week = (7 - current_weekday)
      days_from_now = end_of_week + active_weekdays.min
    end
    now.beginning_of_day.advance days: days_from_now
  end

  def date_of_next(weekday_index)
    date = Date.
    delta = date > Date.today ? 0 : 7
    date + delta
  end

  def time_zone
    config.time_zone
  end

  def active_weekdays
    config.active_weekdays
  end

  def start_time_in_seconds
    config.start_time_in_seconds
  end

  def period_length_in_seconds
    config.period_length_in_seconds
  end

  def end_of_day_in_seconds
    config.end_of_day_in_seconds
  end
end