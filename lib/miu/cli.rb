require 'thor'
require 'miu'

module Miu
  class CLI < ::Thor
    include ::Thor::Actions
    add_runtime_options!

    class << self
      def source_root
        File.expand_path('../../templates', __FILE__)
      end

      def destination_root
        Miu.root
      end
    end

    map ['--version', '-v'] => :version

    desc 'version', 'Show version'
    def version
      say "Miu #{Miu::VERSION}"
    end

    desc 'list', 'Lists plugins'
    def list
      table = Miu.plugins.map { |k, v| [k, "# #{v}" ] }

      say 'Plugins:'
      print_table table, :indent => 2, :truncate => true
      say
    end

    desc 'init', 'Generates a miu configuration files'
    def init
      copy_file 'Gemfile'
      directory 'config'
      empty_directory 'log'
      empty_directory 'tmp/pids'
    end
  end
end

# load built-in plugins
require 'miu/plugins'

