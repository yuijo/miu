require 'miu/messages/base'
require 'miu/resources/text_content'

module Miu
  module Messages
    class Text < Base
      def initialize(options = {})
        options[:type] ||= 'text'
        options[:content] ||= Resources::TextContent.new(options[:content] || {})
        super 
      end
    end
  end
end
