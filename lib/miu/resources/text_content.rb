require 'miu/resources'

module Miu
  module Resources
    class TextContent < Content
      attr_accessor :room, :user, :text

      def initialize(options = {})
        @room = Miu::Utility.adapt(Room, options[:room] || {})
        @user = Miu::Utility.adapt(User, options[:user] || {})
        @text = options[:text]
        super options
      end

      def to_h
        super.merge({
          :room => @room.to_h,
          :user => @user.to_h,
          :text => @text
        })
      end
    end
  end
end
