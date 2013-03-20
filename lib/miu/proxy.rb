require 'miu/socket'
require 'ffi-rzmq'

module Miu
  class Proxy
    attr_reader :frontend, :backend, :capture
    attr_reader :poller

    SEND_TO = '@__proxy_send_to__'

    def initialize(frontend, backend, capture = nil)
      @frontend = unwrap frontend
      @backend = unwrap backend
      @capture = unwrap capture

      @frontend.instance_variable_set SEND_TO, @backend
      @backend.instance_variable_set SEND_TO, @frontend

      @poller = ZMQ::Poller.new
      @poller.register_readable @frontend
      @poller.register_readable @backend
    end

    def run
      loop do
        @poller.poll
        @poller.readables.each do |from|
          loop do
            to = from.instance_variable_get SEND_TO
            msg = ZMQ::Message.new
            from.recvmsg msg
            more = from.more_parts?
            if @capture
              ctrl = ZMQ::Message.new
              ctrl.copy msg.pointer
              @capture.sendmsg ctrl, (more ? ZMQ::SNDMORE : 0)
            end
            to.sendmsg msg, (more ? ZMQ::SNDMORE : 0)
            break unless more
          end
        end
      end
    end

    private

    def unwrap(socket)
      case socket
      when Miu::Socket
        socket.socket
      else
        socket
      end
    end
  end
end
