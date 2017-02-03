require_relative 'config_variable'

class ConfigError < StandardError; end

class Config
  TIME_PATTERN = /\A0?(?<hour>[12]?\d):(?<minute>\d{2})\z/

  # ActiveSupport::TimeZone object of the zone to be used for time manipulation.
  def time_zone
    ActiveSupport::TimeZone[start_time_config.pattern_matches[:zone]].tap do |time_zone|
      raise(ConfigError, "START_TIME time zone is not valid") unless time_zone
    end
  end

  # Period between exercise in seconds.
  def period_length_in_seconds
    @period_length_in_seconds ||= period_length.to_i.minutes.to_i
  end

  # List of active weekdays as an array of integers. Sunday == 0.
  def active_weekdays
    WeekdayConfigVariable.new(name: 'ACTIVE_WEEKDAYS').weekdays
  end

  # Number of seconds since midnight (in the local time zone) that the first notification is sent.
  def start_time_in_seconds
    @start_time_in_seconds ||= seconds_from_time(start_time)
  end

  # Number of seconds since midnight (in the local time zone) at which no more notifications will
  # be sent for the day.
  def end_of_day_in_seconds
    @end_of_day_in_seconds ||= begin
      seconds_from_time(end_time).tap do |end_of_day_in_seconds|
        unless end_of_day_in_seconds > start_time_in_seconds
          raise(ConfigError, "END_TIME must be after START_TIME")
        end
      end
    end
  end

  private

  def time_zone_name
    start_time_config.pattern_matches[:zone]
  end

  # Timestamp of the first notification of each day as a string HH:MM.
  # Should be treated as in the local time zone.
  def start_time
    start_time_config.pattern_matches[:time]
  end

  # Timestamp of the end of the active day as a string HH:MM.
  # Should be treated as in the local time zone.
  def end_time
    ConfigVariable.new(name: 'END_TIME', pattern: TIME_PATTERN, human_pattern: "HH:MM").value
  end

  def period_length
    ConfigVariable.new(name: 'PERIOD_MINUTES', pattern: /\A\d+\z/, human_pattern: "an integer").value
  end

  def seconds_from_time(time)
    matches = TIME_PATTERN.match(time)
    raise(ConfigError, "Time #{time} not valid") unless matches

    (((matches[:hour].to_i * 60) + matches[:minute].to_i) * 60)
  end

  def start_time_config
    ConfigVariable.new(
      name: 'START_TIME',
      pattern: /\A(?<time>[012]?\d:\d{2}) (?<zone>[\/a-zA-Z]+)\z/,
      human_pattern: "'HH:MM zzz' where zzz is the time zone name",
    )
  end
end

class WeekdayConfigVariable < ConfigVariable
  WEEKDAYS = %w(U M T W R F S)

  def initialize(name:)
    super(name: name, pattern: /\AU?M?T?W?R?F?S?\z/, human_pattern: "UMTWRFS")
  end

  # List of active weekdays as an array of integers. Sunday == 0.
  def weekdays
    value.each_char.map { |c| WEEKDAYS.index(c) }
  end
end
