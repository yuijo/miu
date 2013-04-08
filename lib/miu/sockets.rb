require 'miu'
require 'ffi-rzmq'
require 'forwardable'

module Miu
  class Socket
    class << self
      def socket_type(type)
        class_eval <<-EOS
          def socket_type; :#{type.to_s.upcase}; end
        EOS
      end

      def build_address(*args)
        host = args.shift
        port = args.shift
        port ? "tcp://#{host}:#{port}" : host
      end
    end

    attr_reader :socket
    attr_reader :linger

    def initialize
      @socket = Miu.context.socket ::ZMQ.const_get(socket_type)
      @linger = 0
    end

    def bind(address)
      error_wrapper { @socket.bind address }
    end

    def connect(address)
      error_wrapper { @socket.connect address }
    end

    def linger=(value)
      @linger = value || -1
      error_wrapper { @socket.setsockopt(::ZMQ::LINGER, value) }
    end

    def close
      @socket.close
    end

    protected

    def error_wrapper(source = nil, &block)
      error = nil

      begin
        rc = block.call
        error = "#{::ZMQ::Util.error_string} (#{::ZMQ::Util.errno})" unless ::ZMQ::Util.resultcode_ok?(rc)
      rescue => e
        error = e.to_s
      end

      raise IOError, error if error
      true
    end
  end

  module ReadableSocket
    extend Forwardable
    def_delegator :@socket, :more_parts?

    def bind(address)
      self.linger = @linger
      super address
    end

    def connect(address)
      self.linger = @linger
      super address
    end

    def read(buffer = '')
      error_wrapper { @socket.recv_string buffer }
      buffer
    end
  end

  module WritableSocket
    def write(*args)
      error_wrapper { @socket.send_strings args.flatten }
      args
    end

    alias_method :<<, :write
  end


  # pub/sub
  class PubSocket < Socket
    include WritableSocket
    socket_type :pub
  end

  class SubSocket < Socket
    include ReadableSocket
    socket_type :sub

    def subscribe(topic)
      error_wrapper { @socket.setsockopt(::ZMQ::SUBSCRIBE, topic) }
    end

    def unsubscribe(topic)
      error_wrapper { @socket.setsockopt(::ZMQ::UNSUBSCRIBE, topic) }
    end
  end


  # req/rep
  class ReqSocket < Socket
    include ReadableSocket
    include WritableSocket
    socket_type :req
  end

  class RepSocket < Socket
    include ReadableSocket
    include WritableSocket
    socket_type :rep
  end


  # dealer/router
  class DealerSocket < Socket
    include ReadableSocket
    include WritableSocket
    socket_type :dealer
  end

  class RouterSocket < Socket
    include ReadableSocket
    include WritableSocket
    socket_type :router
  end


  # push/pull
  class PushSocket < Socket
    include WritableSocket
    socket_type :push
  end

  class PullSocket < Socket
    include ReadableSocket
    socket_type :pull
  end


  # xpub/xsub
  class XPubSocket < PubSocket
    socket_type :xpub
  end

  class XSubSocket < SubSocket
    socket_type :xsub

    def subscribe(topic)
      true
    end

    def unsubscribe(topic)
      true
    end
  end
end
