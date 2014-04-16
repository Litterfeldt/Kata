# encoding: utf-8
require 'forwardable'
require 'redis'
require 'redis/namespace'

module Kata
  module Storage
    #handles all database comunication
    #is to be instantiated with an options hash
    class Client
      extend Forwardable

      def self.connect(options)
        redis = Redis.new(options[:redis])
        new Redis::Namespace.new(options[:namespace], redis: redis)
      end

      def initialize(redis)
        @redis = redis
      end

      attr_accessor :redis
      def_delegators :@redis, :get, :set, :hget, :hset, :del,
                     :setex, :hdel, :hgetall, :keys,
                     :sadd, :srem, :sismember, :smembers, :flushall

      def scache(key, &block)
        sadd(key, yield)
      end

      def hcache(key, field, &block)
        key = "hcache:#{key}"
        hget(key, field) || store_in_hash(key, field, yield)
      end

      private

      def store_in_hash(key, field, value)
        return if value.nil?

        value = value.to_s

        unless value.empty?
          hset(key, field, value)
          save_key_last_modified(key)
        end

        value
      end

      def save_key_last_modified(key)
        hset("last_modified_keys", key, timestamp)
      end

      def timestamp
        Time.now.iso8601
      end
    end
  end
end
