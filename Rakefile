require 'rubygems'
require 'bundler/setup'

unless ENV['ENVIRONMENT'] == 'production'
  begin
    require 'dotenv'
    Dotenv.load
  rescue LoadError
    ENV['ENVIRONMENT'] = 'production'
  end
end

if ENV['ENVIRONMENT'] == 'production'
  Bundler.require(:default)
else
  Bundler.require(:default, :development)
end

NewRelic::Agent.manual_start
