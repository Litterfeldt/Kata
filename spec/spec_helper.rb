# encoding: utf-8
require 'fakeredis'
require 'test/unit'
require 'rack/test'
require 'server'

RSpec.configure do |config|
  config.before(:all) do
    ENV['RACK_ENV'] = 'test'
  end
end
