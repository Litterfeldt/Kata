# encoding: utf-8
require 'sinatra/base'
require 'sinatra/config_file'
require 'sinatra/json'
require 'thin'

require 'storage/init'
require 'controllers/init'
require 'services/init'
require 'storage_adapters/init'

module Kata
  #Main webserver class, all routes and controller declaration goes here
  class Server < Sinatra::Application
    register Sinatra::ConfigFile

    set :public_folder, './app/views/assets'

    configure :production do
      set :show_exceptions, false
    end

    configure do
      set :environments, %w{ development test stage production }
      config_file 'config.yml'
      Storage.setup settings.storage
    end

    register Kata::Controller::ViewController
    register Kata::Controller::DictionaryController
  end
end

