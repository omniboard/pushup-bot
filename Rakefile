require 'rubygems'
require 'bundler/setup'

  require 'dotenv'
  Dotenv.load
unless ENV['ENVIRONMENT'] == 'production'
end

if ENV['ENVIRONMENT'] == 'production'
  Bundler.require(:default)
else
  Bundler.require(:default, :development)
end

NewRelic::Agent.manual_start
