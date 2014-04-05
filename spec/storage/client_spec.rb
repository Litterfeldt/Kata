# encoding: utf-8
require 'spec_helper'

require 'storage/client'

describe Kata::Storage::Client do
  subject { Kata::Storage::Client }

  let(:redis)  { Redis.new }
  let(:client) { subject.new(redis) }

  after :all do
    client.redis.flushall
  end

  context "forwards to redis" do
    let(:redis) { double() }

    it "delegates set" do
      redis.should_receive(:set).with('foo', 'bar')
      subject.new(redis).set('foo', 'bar')
    end

    it "delegates get" do
      redis.should_receive(:get).with('foo')
      subject.new(redis).get('foo')
    end

    it "delegates hget" do
      redis.should_receive(:hget).with('foo', 'bar')
      subject.new(redis).hget('foo', 'bar')
    end

    it "delegates hset" do
      redis.should_receive(:hset).with('foo', 'bar', '123')
      subject.new(redis).hset('foo', 'bar', '123')
    end

    it "delegates hgetall" do
      redis.should_receive(:hgetall).with('foo')
      subject.new(redis).hgetall('foo')
    end

    it "delegates keys" do
      redis.should_receive(:keys).with('pattern')
      subject.new(redis).keys('pattern')
    end

    it "delegates sadd" do
      redis.should_receive(:sadd).with('foo', 'bar')
      subject.new(redis).sadd('foo', 'bar')
    end

    it "delegates srem" do
      redis.should_receive(:srem).with('foo', 'bar')
      subject.new(redis).srem('foo', 'bar')
    end

    it "delegates sismember" do
      redis.should_receive(:sismember).with('foo', 'bar')
      subject.new(redis).sismember('foo', 'bar')
    end

    it "delegates smembers" do
      redis.should_receive(:smembers).with('foo')
      subject.new(redis).smembers('foo')
    end
  end

  describe "hcache" do
    context "string stored in redis" do
      before do
        redis.hset('hcache:foo', 'bar', 'baz')
      end

      it "returns the value from redis" do
        client.hcache('foo', 'bar').should == 'baz'
      end

      it "does not store a new value" do
        client.should_not_receive(:store_in_hash)
        client.hcache('foo', 'bar') do
          'value'
        end
      end
    end

    context "string not stored in redis" do
      before do
        redis.flushall
      end
      it "stores a new value" do
        client.should_receive(:store_in_hash).with('hcache:foo', 'bar', 'value')
        client.hcache('foo', 'bar') { 'value' }
      end

      it "returns the value" do
        client.hcache('x', 'y') { 123 }.should == '123'
      end

      it "saves a timestamp" do
        client.should_receive(:save_key_last_modified).with('hcache:foo')
        client.hcache('foo', 'bar') { 'value' }
      end
    end
  end
end
