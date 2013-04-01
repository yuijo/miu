require 'miu/socket'
require 'miu/publishable'
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
        klass.send :include, Publishable
        klass.send :include, self

        klass.new.tap do |pub|
          pub.connect host, port
        end
      end
    end
  end
end
