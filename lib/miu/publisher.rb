require 'miu/sockets'
require 'miu/writable'
require 'miu/utility'

module Miu
  module Publisher
    class << self
      def new(*args, &block)
        options = Miu::Utility.extract_options! args
        host = args.shift || '127.0.0.1'
        port = args.shift || Miu.default_sub_port
        socket = options[:socket] || PubSocket

        klass = Class.new(socket, &block)
        klass.send :include, Writable

        klass.new.tap do |pub|
          address = Miu::Socket.build_address host, port
          pub.connect address
        end
      end

      def included(base)
        base.extend ClassMethods
      end
    end

    module ClassMethods
      def socket_type(socket = nil)
        if socket
          @socket_type = socket
        else
          @socket_type
        end
      end
    end

    attr_reader :publisher

    def initialize(topic, *args)
      @publisher = Miu::Publisher.new *args, :socket => self.class.socket_type
      @topic = topic
    end

    def close
      @publisher.close
    end

    def write(message)
      @publisher.write @topic, message
    end
  end
end
