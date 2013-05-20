require 'miu/errors'
require 'msgpack'

module Miu
  class Packet
    attr_accessor :topic, :data

    def initialize(topic, data)
      @topic = topic.to_s
      @data = data
    end

    def to_h
      {
        :topic => @topic,
        :data => @data.to_h
      }
    end

    def dump
      [@topic, @data.to_msgpack]
    end

    def self.load(parts)
      topic = parts[0]
      data = MessagePack.unpack(parts[1])
      new topic, data
    rescue => e
      raise PacketLoadError, e
    end

    def to_s
      "<#{topic}> #{data.to_h}"
    end

    def inspect
      inspection = [:topic, :data].map do |name|
        "#{name}: #{__send__(name).inspect}"
      end.join(', ')
      "#<#{self.class} #{inspection}>"
    end
  end
end
