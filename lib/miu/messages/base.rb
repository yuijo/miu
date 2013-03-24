require 'miu/type'
require 'miu/resources'
require 'msgpack'
require 'securerandom'
require 'forwardable'

module Miu
  module Messages
    class Base
      attr_accessor :id, :time
      attr_accessor :network, :type, :content

      extend Forwardable
      def_delegators :@type, :content_type, :sub_type

      def initialize(options = {})
        @id = options[:id] || SecureRandom.uuid
        @time = options[:time] || Time.now.to_i
        @network = Miu::Utility.adapt(Resources::Network, options[:network] || {})
        @type = Miu::Type.new(options[:type], options[:sub_type])
        @content = options[:content]
        yield self if block_given?
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
        types[type.to_s] || Unknown
      end
    end
  end
end
