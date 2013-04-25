require 'miu'
require 'ffi-rzmq'

module Miu
  class Server
    attr_reader :options
    attr_reader :forwarder

    def initialize(options = {})
      @options = options
    end

    def run
      Logger.info "Starting Miu #{Miu::VERSION} (ZeroMQ #{ZMQ::LibZMQ.version.values.join('.')})"
      Logger.info "Publish on #{@options[:pub_host]}:#{@options[:pub_port]}"
      Logger.info "Subscribe on #{@options[:sub_host]}:#{@options[:sub_port]}"

      register_signal_handlers

      @forwarder = Forwarder.new @options
      @forwarder.run
    rescue => e
      Miu::Logger.exception e
    end

    def close
      @forwarder.close
    end

    def register_signal_handlers
      %w(INT TERM HUP QUIT).each do |sig|
        trap(sig) do
          close
          exit
        end
      end

      at_exit do
        Logger.info 'Quit...'
      end
    end
  end
end
