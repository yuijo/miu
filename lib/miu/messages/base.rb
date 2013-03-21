require 'miu/resources'
require 'msgpack'

module Miu
  module Messages
    class Base
      attr_accessor :network, :type, :content

      def initialize(options = {})
        @network = options[:network] || Resources::Network.new(options[:network] || {})
        @type = options[:type]
        @type = [@type, *Array(options[:sub_type])].compact.join('.')
        @content = options[:content]
        yield self if block_given?
      end

      def sub_type
        @type.to_s.split('.', 2).last
      end

      def to_hash
        {:network => @network.to_hash, :type => @type, :content => @content.to_hash}
      end

      def to_msgpack(*args)
        to_hash.to_msgpack(*args)
      end
    end

    class Unknown < Base
    end

    class << self
      def types
        @types ||= {}
      end

      def register(type, klass)
        types[type.to_s] = klass
      end

      def guess(type)
        type = type.to_s.split('.', 2).first
        types[type] || Unknown
      end
    end
  end
end