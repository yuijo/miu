require 'miu/resources'
require 'miu/messages'

module Miu
  module Messages
    class Text < Base
      def initialize(options = {})
        options[:type] ||= 'text'
        options[:content] ||= Resources::TextContent.new(options[:content] || {})
        super 
      end
    end

    register :text, Text
  end
end
