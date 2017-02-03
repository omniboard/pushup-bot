class ConfigVariable
  def initialize(name:, default: nil, pattern: nil, human_pattern: nil)
    self.name = name
    self.default = default
    self.pattern = pattern
    self.human_pattern = human_pattern

    self.value = ENV[name] || default || raise(ConfigError, "#{name} is required")
    if pattern
      pattern_matches || raise(ConfigError, "#{name} expected to look like #{human_pattern}")
    end
  end

  attr_reader :value

  def pattern_matches
    @pattern_matches ||= pattern.match(value)
  end

  private

  attr_accessor :name
  attr_accessor :default
  attr_accessor :pattern
  attr_writer :human_pattern

  attr_writer :value

  def human_pattern
    @human_pattern || pattern.to_s
  end
end
