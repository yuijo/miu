require 'miu/resources'
require 'miu/messages/base'

module Miu
  module Messages
    class Text < Base
      attr_accessor :room, :user, :text

      def initialize(options = {})
        options[:type] ||= 'text'
        @room = Miu::Utility.adapt(Miu::Resources::Room, options[:room] || {})
        @user = Miu::Utility.adapt(Miu::Resources::User, options[:user] || {})
        @text = options[:text]
        super 
      end

      def to_h
        super.merge({
          :room => @room.to_h,
          :user => @user.to_h,
          :text => @text
        })
      end
    end

    register :text, Text
  end
end
