require 'miu'

module Miu
  module Plugin
    def self.included(base)
      STDOUT.sync = true
      STDERR.sync = true

      base.extend ClassMethods
      base.called_from = begin
        call_stack = caller.map { |p| p.sub(/:\d+.*/, '') }
        File.dirname(call_stack.detect { |p| p !~ %r(miu[\w.-]*/lib/miu/plugins) })
      end
    end

    module ClassMethods
      attr_accessor :called_from

      def register(*args, &block)
        options = args.last.is_a?(::Hash) ? args.pop : {}
        name = args.shift
        plugin = args.shift || self
        Miu.register name, plugin, options, &block
      end
    end
  end
end
