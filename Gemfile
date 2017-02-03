source 'https://rubygems.org'

ruby '2.3.3'

gem 'rake'

# A useful console
gem 'pry-byebug'
gem 'pry-doc'
gem 'pry-rails'
gem 'pry-remote'
gem 'pry-rescue'
gem 'pry-stack_explorer'

# Performance monitoring and exception reporting
gem 'newrelic_rpm'

# Exception reporting to Sentry
gem "sentry-raven"

# Interaction with Slack
gem 'slack-ruby-client'

# Time zone manipulation
gem 'activesupport'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # Testing. These are also needed in development so that Rails generators are available.
  gem 'rspec'
  gem 'rspec-collection_matchers'
  gem 'rspec-mocks'
  gem 'shoulda'
  gem 'dotenv'
  gem 'rspec_junit_formatter'
end

group :test do
  gem 'coveralls', require: false
  gem 'timecop'
  gem 'webmock'
  gem 'codacy-coverage', require: false
end

