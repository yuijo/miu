require 'msgpack'

module Miu
  class Type
    def initialize(*args)
      @tokens = args
      @tokens.compact!
      @tokens.map! { |t| t.to_s.split('.') }
      @tokens.flatten!
    end

    def content_type
      @tokens[0] || ''
    end

    def sub_type
      @tokens[1..-1].join('.') rescue ''
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
