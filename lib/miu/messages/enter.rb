require 'miu/resources'
require 'miu/messages/base'

module Miu
  module Messages
    class Enter < Base
      def initialize(options = {})
        options[:type] ||= 'enter'
        options[:content] = Miu::Utility.adapt(Resources::EnterContent, options[:content] || {})
        super 
      end
    end

    register :enter, Enter
  end
end
