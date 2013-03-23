require 'miu'
require 'msgpack'

module Miu
  class Packet
    attr_accessor :tag, :message

    def initialize(tag, message)
      @tag = tag
      @message = message
    end

    def dump
      [@tag.to_s, @message.to_msgpack]
    end

    def self.load(parts)
      tag = parts.shift
      message = MessagePack.unpack(parts.shift)
      new tag, message
    end

    def inspect
      inspection = [:tag, :message].map do |name|
        "#{name}: #{__send__(name).inspect}"
      end.join(', ')
      "#<#{self.class} #{inspection}>"
    end
  end
end
