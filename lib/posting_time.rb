require 'active_support'

##
# Performs the math necessary to decide when to post the next message.
class PostingTime
  def initialize(config:, now:)
    self.config = config
    self.now = now.in_time_zone(config.time_zone)
  end

  def next
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
    now.beginning_of_day.advance days: days_until_next_active_day
  end

  def days_until_next_active_day
    # any days left this week?
    if current_weekday < active_weekdays.max
      next_active_weekday = active_weekdays.sort.find { |wday| wday > current_weekday }
      next_active_weekday - current_weekday
    else
      end_of_week = (7 - current_weekday)
      end_of_week + active_weekdays.min
    end
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
