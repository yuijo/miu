require 'miu'
require 'securerandom'
require 'msgpack'

module Miu
  class Packet
    attr_accessor :tag, :body, :id, :time

    def initialize(tag, body, options = {})
      @tag = tag
      @body = body
      @id = options[:id] || SecureRandom.uuid
      @time = options[:time] || Time.now.to_i
    end

    def dump
      data = {
        'body' => @body,
        'id' => @id,
        'time' => @time,
      }
      [@tag, data.to_msgpack]
    end

    def self.load(parts)
      tag = parts.shift
      data = MessagePack.unpack(parts.shift)
      body = data.delete('body')
      new tag, body, Miu::Utility.symbolize_keys(data)
    end

    def inspect
      inspection = [:tag, :body, :id, :time].map do |name|
        "#{name}: #{__send__(name).inspect}"
      end.join(', ')
      "#<#{self.class} #{inspection}>"
    end
  end
end
