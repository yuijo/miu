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

      def to_hash
        {
          :network => @network.to_hash,
          :type => @type,
          :content => @content ? @content.to_hash : {}
        }
      end

      def to_msgpack(*args)
        to_hash.to_msgpack(*args)
      end
    end

    class Unknown < Base
    end
  end
end
