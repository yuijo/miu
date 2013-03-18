require 'miu/resources/network'
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

      def to_hash
        {:network => @network.to_hash, :type => @type, :content => @content.to_hash}
      end

      def to_msgpack(*args)
        to_hash.to_msgpack(*args)
      end
    end
  end
end
