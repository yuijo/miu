require 'miu/publisher'
require 'miu/subscriber'
require 'miu/proxy'
require 'ffi-rzmq'

module Miu
  class Forwarder
    def initialize(options = {})
      @publisher = Publisher.new({
        :socket_type => pub_socket_type,
        :host => options[:pub_host],
        :port => options[:pub_port]
      })
      @publisher.bind

      @subscriber = Subscriber.new({
        :socket_type => sub_socket_type,
        :host => options[:sub_host],
        :port => options[:sub_port]
      })
      @subscriber.bind
      @subscriber.subscribe
    end

    def close
      @subscriber.close
      @publisher.close
    end

    def run
      proxy = Proxy.new @subscriber, @publisher
      proxy.run
    end

    private

    def pub_socket_type
      if ZMQ::LibZMQ.version3?
        ZMQ::XPUB
      else
        ZMQ::PUB
      end
    end

    def sub_socket_type
      if ZMQ::LibZMQ.version3?
        ZMQ::XSUB
      else
        ZMQ::SUB
      end
    end
  end
end
