require 'miu/resources'

module Miu
  module Resources
    class TextContent < Content
      attr_accessor :room, :user, :text

      def initialize(options = {})
        @room = options[:room] || Room.new(options[:room] || {})
        @user = options[:user] || User.new(options[:user] || {})
        @text = options[:text]
        super options
      end

      def to_hash
        super.merge({
          :room => @room.to_hash,
          :user => @user.to_hash,
          :text => @text
        })
      end
    end
  end
end
