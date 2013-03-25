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
      Logger.info "Subscribe #{options[:bridge] ? 'from' : 'on'} #{@options[:sub_host]}:#{@options[:sub_port]}"

      [:INT, :TERM].each do |sig|
        trap(sig) do
          Logger.info "Quit"
          close
          exit
        end
      end

      @forwarder = Forwarder.new @options
      @forwarder.run
    rescue => e
      Miu::Logger.exception e
    end

    def close
      @forwarder.close
    end
  end
end
