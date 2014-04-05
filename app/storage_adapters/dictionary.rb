# encoding: utf-8
require 'storage/init'
module Kata
  module StorageAdapter
    #Dictionary storage adapter, handles storage procedures
    #for storing and fetching dictionary items.
    class Dictionary
      def get_anagrams key
        smembers key
      end

      def add_word key, word
        sadd key, word
      end

      def flush_db
        Storage::client.flushall
      end

      private

      def smembers key
        Storage::client.smembers key
      end

      def sadd key, member
        Storage::client.sadd key, member
      end
    end
  end
end
