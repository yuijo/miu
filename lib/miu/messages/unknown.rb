require 'miu/messages/base'

module Miu
  module Messages
    class Unknown < Base
      def initialize(value)
        super({:type => 'unknown', :content => value})
      end
    end
  end
end
