require 'miu/sockets'
require 'miu/readable'
require 'miu/utility'

module Miu
  module Subscriber
    class << self
      def new(*args, &block)
        options = Miu::Utility.extract_options! args
        host = args.shift || '127.0.0.1'
        port = args.shift || Miu.default_pub_port
        socket = options[:socket] || SubSocket

        klass = Class.new(socket, &block)
        klass.send :include, Readable

        klass.new.tap do |sub|
          address = Miu::Socket.build_address host, port
          sub.connect address
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

    attr_reader :subscriber

    def initialize(host, port, tag)
      @subscriber = Miu::Subscriber.new host, port, :socket => self.class.socket_type
      self.tag = tag
    end

    def close
      @subscriber.close
    end

    def tag=(value)
      @subscriber.unsubscribe @tag if @tag
      @subscriber.subscribe value
      @tag = value
    end

    def tag
      @tag
    end

    def run
      @subscriber.each do |packet|
        begin
          on_packet packet
        rescue Exception => e
          Miu::Logger.exception e
        end
      end
    end

    protected

    def on_packet(packet)
      name = method_name packet
      __send__ name, packet.tag, packet.data if respond_to?(name)
    end

    def method_name(packet)
      "on_#{packet.data.type}"
    end
  end
end
