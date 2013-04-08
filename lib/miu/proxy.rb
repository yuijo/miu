require 'miu/sockets'
require 'ffi-rzmq'

module Miu
  class Proxy
    attr_reader :frontends, :backends
    attr_reader :poller

    PROXY_TO = '@__proxy_to__'

    def initialize(frontends, backends)
      @frontends = Array(frontends).map { |s| unwrap s }
      @backends = Array(backends).map { |s| unwrap s }

      @frontends.each { |s| s.instance_variable_set PROXY_TO, @backends }
      @backends.each { |s| s.instance_variable_set PROXY_TO, @frontends }

      @poller = ::ZMQ::Poller.new
      @frontends.each { |s| @poller.register_readable s }
      @backends.each { |s| @poller.register_readable s }
    end

    def run
      loop do
        @poller.poll
        @poller.readables.each do |from|
          loop do
            msg = ::ZMQ::Message.new
            from.recvmsg msg
            more = from.more_parts?

            proxy_to = from.instance_variable_get PROXY_TO
            proxy_to.each do |to|
              ctrl = ::ZMQ::Message.new
              ctrl.copy msg.pointer
              to.sendmsg ctrl, (more ? ::ZMQ::SNDMORE : 0)
            end

            msg.close
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
