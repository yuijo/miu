require 'miu/messages'
require 'msgpack'
require 'securerandom'

module Miu
  module Messages
    class Base
      attr_accessor :id, :time
      attr_accessor :network, :type, :content

      def initialize(options = {})
        @id = options[:id] || SecureRandom.uuid
        @time = options[:time] || Time.now.to_i
        @network = Miu::Utility.adapt(Resources::Network, options[:network] || {})
        @type = options[:type]
        @content = options[:content]
        yield self if block_given?
      end

      def to_h
        {
          :id => @id,
          :time => @time,
          :network => @network.to_h,
          :type => @type,
          :content => @content ? @content.to_h : {}
        }
      end

      def to_msgpack(*args)
        to_h.to_msgpack(*args)
      end
    end
  end
end
