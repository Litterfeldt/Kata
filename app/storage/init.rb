# encoding: utf-8
require 'storage/client'

module Kata
  #instantiates the storage client
  module Storage
    class << self
      attr_reader :client

      def setup(options)
        @client = Client.connect(options)
      end
    end
  end
end
