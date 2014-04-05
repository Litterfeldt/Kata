# encoding: utf-8
module Kata
  module Controller
    #Dictionary Controller, routes all dictionary related routes
    module DictionaryController
      def self.registered(app)
        app.get '/search/:q' do
          response = Service::Anagram.new.get_anagrams params[:q]
          halt 404 if response.empty?
          json response
        end

        app.post '/dictionary' do
          halt 500 unless params[:file]
          halt 500 unless params[:file][:type] == 'text/plain'
          halt 500 unless file = params[:file][:tempfile].read
          halt 500 unless Service::Anagram.new.add_dictionary_file file
        end

        app.post '/reset-dictionary' do
          Service::Anagram.new.empty_dictionary
        end
      end
    end
  end
end
