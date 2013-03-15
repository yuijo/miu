require 'msgpack'

module Miu
  class Packet
    attr_accessor :tag, :time, :body

    def initialize(*args)
      @tag = args.shift
      @body = args.pop
      @time = args.shift || Time.now.to_i
    end

    def dump
      [@tag, @time, @body.to_msgpack].map(&:to_s)
    end

    def self.load(parts)
      tag = parts.shift
      time = parts.shift
      body = MessagePack.unpack(parts.shift)
      new tag, time, body
    end
  end
end
