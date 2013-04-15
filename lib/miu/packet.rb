require 'miu/errors'
require 'msgpack'

module Miu
  class Packet
    attr_accessor :tag, :data

    def initialize(tag, data)
      @tag = tag
      @data = data
    end

    def dump
      [@tag.to_s, @data.to_msgpack]
    end

    def self.load(parts)
      tag = parts[0]
      data = MessagePack.unpack(parts[1])
      new tag, data
    rescue => e
      raise PacketLoadError, e
    end

    def to_s
      "<#{tag}> #{data.to_hash}"
    end

    def inspect
      inspection = [:tag, :data].map do |name|
        "#{name}: #{__send__(name).inspect}"
      end.join(', ')
      "#<#{self.class} #{inspection}>"
    end
  end
end
