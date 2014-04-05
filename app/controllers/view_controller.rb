# encoding: utf-8
module Kata
  module Controller
    #View Controller, routes all view related routes
    module ViewController
      def self.registered(app)
        app.get '/' do
          File.open('./app/views/index.html', File::RDONLY)
        end
      end
    end
  end
end
