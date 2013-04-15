require 'logger'

module Miu
  module Logger
    module_function

    %w(debug info warn error fatal).each do |name|
      eval <<-EOS
        def #{name}(msg)
          Miu.logger.#{name}(msg) if Miu.logger
        end
      EOS
    end

    def exception(*args)
      ex = args.pop
      error [*args, format_exception(ex)].join("\n")
    end

    def format_exception(ex)
      rows = []
      rows << "#{ex.class}: #{ex.to_s}"
      rows += ex.backtrace.map { |s| "\tfrom #{s}" }
      rows.join("\n")
    end

    def formatter(severity, time, progname, msg)
      "[#{time}] #{msg}\n"
    end
  end

  class << self
    attr_accessor :default_logger
    attr_accessor :logger
  end

  self.default_logger = ::Logger.new(STDERR)
  self.logger = self.default_logger
  self.logger.level = ::Logger::INFO
  self.logger.formatter = Miu::Logger.method(:formatter)
end
