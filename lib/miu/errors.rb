module Miu
  class Error < StandardError
  end

  class WrappedError < Error
    attr_accessor :error
    
    def initialize(error)
      @error = error
    end
  end

  class PacketLoadError < WrappedError
  end

  class MessageLoadError < WrappedError
  end
end
