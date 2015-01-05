module Miu
  module SocketHelpers
    def establish(socket, options = {})
      Array(options[:bind]).each { |addr| socket.bind addr }
      Array(options[:connect]).each { |addr| socket.connect addr }
    end
  end
end
