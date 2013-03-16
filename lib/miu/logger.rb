require 'logger'

module Miu
  module Logger
    module_function

    %w(debug info warn error fatal).each do |name|
      instance_eval <<-EOS
        def #{name}(msg)
          Miu.logger.#{name}(msg) if Miu.logger
        end
      EOS
    end

    def exception(msg, ex)
      error %(#{msg}\n#{format_exception(ex)})
    end

    def format_exception(ex)
      %(#{ex.class}: #{ex.to_s}\n#{ex.backtrace.join("\n")})
    end

    def formatter(severity, time, progname, msg)
      "[#{time}] #{msg}\n"
    end
  end

  class << self
    attr_accessor :logger
  end
  self.logger = ::Logger.new(STDERR)
  self.logger.level = ::Logger::INFO
  self.logger.formatter = Miu::Logger.method(:formatter)
end
