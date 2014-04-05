# encoding: utf-8
require 'spec_helper'

describe Kata::Server do
  include Rack::Test::Methods

  before :all do
    Kata::Storage::client.redis.flushall
  end

  def app
    Kata::Server
  end

  describe 'REST-API' do
    context 'empty db' do
      it 'returns no anagrams' do
        get '/search/cat'
        expect(last_response.status).to eq 404
      end
    end

    context 'populate db' do
      let(:dictionary_file) {
        Rack::Test::UploadedFile.new(
          './spec/fixtures/dictionary.txt',
          'text/plain'
        )
      }
      let(:binary_file) {
        Rack::Test::UploadedFile.new(
          './spec/fixtures/empty.txt',
          'image/png'
        )
      }
      let(:empty_file) {
        Rack::Test::UploadedFile.new(
          './spec/fixtures/empty.txt',
          'text/plain'
        )
      }

      it 'handles a text file' do
        post '/dictionary', file: dictionary_file
        expect(last_response).to be_ok
        last_response.body.should == ""
      end

      it 'handles an empty file' do
        post '/dictionary', file: empty_file
        expect(last_response).to be_ok
        last_response.body.should == ""
      end

      it 'handles a binary file' do
        post '/dictionary', file: binary_file
        expect(last_response).not_to be_ok
        last_response.body.should == ""
      end
    end

    context 'populated db' do
      it 'returns anagram' do
        get '/search/cat'
        expect(last_response).to be_ok
        last_response.body.should == JSON.dump({ 'cat' => ['act','tac'] })
      end

      it 'returns anagrams of multiple words' do
        get '/search/cat%20top'
        expect(last_response).to be_ok
        last_response.body.should ==
          JSON.dump({ 'cat' => ['act','tac'], 'top' => ["opt","pot"] })
      end
    end

    context 'flush db' do
      it 'empties the database' do
        post '/reset-dictionary'
        expect(last_response).to be_ok
        get '/search/cat'
        expect(last_response.status).to eq 404
      end
    end
  end
end
