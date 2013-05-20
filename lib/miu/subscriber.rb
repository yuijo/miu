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

    def initialize(topic, *args)
      options = Miu::Utility.extract_options! args
      @subscriber = Miu::Subscriber.new *args, :socket => self.class.socket_type
      self.topic = topic
    end

    def close
      @subscriber.close
    end

    def topic=(value)
      @subscriber.unsubscribe @topic if @topic
      @subscriber.subscribe value
      @topic = value
    end

    def topic
      @topic
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
      __send__ name, packet.topic, packet.data if respond_to?(name, true)
    end

    def method_name(packet)
      "on_#{packet.data.type}"
    end
  end
end
