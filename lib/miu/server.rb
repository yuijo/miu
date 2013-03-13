require 'miu'
require 'zmq'

module Miu
  class Server
    attr_reader :options
    attr_reader :context, :pull_socket, :sub_socket

    def initialize(options = {})
      @options = options
    end

    def run
      pull_address = "#{@options[:pull_host]}:#{@options[:pull_port]}"
      pub_address = "#{@options[:pub_host]}:#{@options[:pub_port]}"

      @context = ZMQ::Context.new
      @pull_socket = @context.socket ZMQ::PULL
      @pull_socket.bind "tcp://#{pull_address}"
      @pub_socket = @context.socket ZMQ::PUB
      @pub_socket.bind "tcp://#{pub_address}"

      puts "Starting miu"
      puts "pull: #{pull_address}"
      puts "pub: #{pub_address}"

      trap(:INT) do
        puts "Quit..."
        shutdown
        exit
      end

      loop do
        msg = @pull_socket.recv
        p msg
        @pub_socket.send msg
      end
    end

    def shutdown
      @pub_socket.close
      @pull_socket.close
      @context.close
    end
  end
end
