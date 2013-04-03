module Miu
  class Error < StandardError
  end

  class WrappedError < Error
    attr_accessor :error
    
    def initialize(error)
      @error = error
      super "#{@error.class}: #{@error.to_s}"
    end
  end

  class InvalidTypeError < Error
  end

  class PacketLoadError < WrappedError
  end

  class MessageLoadError < WrappedError
  end
end
