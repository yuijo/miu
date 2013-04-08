require 'miu/sockets'
require 'miu/subscribable'
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
        klass.send :include, Subscribable
        klass.send :include, self

        klass.new.tap do |sub|
          address = Miu::Socket.build_address host, port
          sub.connect address
        end
      end
    end
  end
end
