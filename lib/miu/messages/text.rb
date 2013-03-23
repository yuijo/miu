require 'miu/resources'
require 'miu/messages'

module Miu
  module Messages
    class Text < Base
      def initialize(options = {})
        options[:type] ||= 'text'
        options[:content] = Miu::Utility.adapt(Resources::TextContent, options[:content])
        super 
      end
    end

    register :text, Text
  end
end
