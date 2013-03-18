require 'miu'

module Miu
  class Server
    attr_reader :options
    attr_reader :publisher, :subscriber

    def initialize(options = {})
      @options = options
      if options[:verbose] && Miu.logger
        Miu.logger.level = ::Logger::DEBUG
      end
    end

    def run
      pub_address = "#{@options[:pub_host]}:#{@options[:pub_port]}"
      sub_address = "#{@options[:sub_host]}:#{@options[:sub_port]}"

      @publisher = Publisher.new({:host => @options[:pub_host], :port => @options[:pub_port]})
      @subscriber = Subscriber.new({:host => @options[:sub_host], :port => @options[:sub_port]})

      @publisher.bind
      @subscriber.bind

      Logger.info "Starting miu"
      Logger.info "pub: #{@publisher.host}:#{@publisher.port}"
      Logger.info "sub: #{@subscriber.host}:#{@subscriber.port}"

      [:INT, :TERM].each do |sig|
        trap(sig) do
          Logger.info "Quit"
          close
          exit
        end
      end

      loop do
        parts = @subscriber.forward @publisher
        if @options[:verbose]
          packet = Packet.load parts
          Logger.debug packet.inspect
        end
      end
    end

    def close
      @subscriber.close
      @publisher.close
    end
  end
end
