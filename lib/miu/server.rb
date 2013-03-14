require 'miu'
require 'miu/publisher'
require 'miu/subscriber'

module Miu
  class Server
    attr_reader :options
    attr_reader :context, :publisher, :subscriber

    def initialize(options = {})
      @options = options
    end

    def run
      pub_address = "#{@options[:pub_host]}:#{@options[:pub_port]}"
      sub_address = "#{@options[:sub_host]}:#{@options[:sub_port]}"

      @context = ZMQ::Context.new
      @publisher = Publisher.new({
        :context => @context,
        :host => @options[:pub_host],
        :port => @options[:pub_port]
      })
      @subscriber = Subscriber.new({
        :context => @context,
        :host => @options[:sub_host],
        :port => @options[:sub_port]
      })

      @publisher.bind
      @subscriber.bind

      puts "Starting miu"
      puts "pub: #{@publisher.host}:#{@publisher.port}"
      puts "sub: #{@subscriber.host}:#{@subscriber.port}"

      trap(:INT) do
        puts "Quit"
        close
        exit
      end

      loop do
        @subscriber.forward @publisher
      end
    end

    def close
      @subscriber.close
      @publisher.close
      @context.terminate
    end
    alias_method :shutdown, :close
  end
end
