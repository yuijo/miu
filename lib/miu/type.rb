require 'msgpack'

module Miu
  class InvalidTypeError < StandardError
  end

  class Type
    def initialize(*args)
      @tokens = args
      @tokens.compact!
      @tokens.map! { |t| t.to_s.split('.') }
      @tokens.flatten!
      raise InvalidTypeError if @tokens.empty?
    end

    def content_type
      @tokens[0] || ''
    end

    def sub_type
      @tokens[1..-1].join('.') || ''
    end

    def sub_type?
      !sub_type.empty?
    end

    def to_s
      @tokens.join('.')
    end

    def to_msgpack(*args)
      to_s.to_msgpack(*args)
    end
  end
end
