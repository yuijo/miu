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
        klass.send :include, self

        klass.new.tap do |pub|
          address = Miu::Socket.build_address host, port
          pub.connect address
        end
      end
    end
  end
end
