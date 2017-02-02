require 'rubygems'
require 'bundler/setup'

if ['development', 'test'].include? ENV['RAILS_ENV']
  require 'dotenv'
  Dotenv.load
end

if ENV['RAILS_ENV'] == 'production'
  Bundler.require(:default)
else
  Bundler.require(:default, :development)
end

NewRelic::Agent.manual_start
