require 'miu/messages'
require 'msgpack'

module Miu
  module Messages
    class Base
      attr_accessor :id, :time
      attr_accessor :network, :type, :meta

      class << self
        def uuid
          require 'securerandom'
          SecureRandom.uuid
        end

        def now
          require 'time'
          Time.now.to_i
        end
      end

      def initialize(options = {})
        @id = options[:id] || self.class.uuid
        @time = options[:time] || self.class.now
        @network = Miu::Utility.adapt(Miu::Resources::Network, options[:network] || {})
        @type = options[:type]
        @meta = options[:meta] || {}
        yield self if block_given?
      end

      def to_h
        {
          :id => @id,
          :time => @time,
          :network => @network.to_h,
          :type => @type,
          :meta => @meta
        }
      end

      def to_msgpack(*args)
        to_h.to_msgpack(*args)
      end
    end
  end
end
