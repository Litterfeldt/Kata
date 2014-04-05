# encoding: utf-8
require 'storage/client'

module Kata
  #instantiates the storage client
  module Storage
    class << self
      def setup(options)
        @client = Client.connect(options)
      end

      def client
        @client
      end
    end
  end
end
