require 'thor'
require 'miu'

module Miu
  class CLI < ::Thor
    include ::Thor::Actions
    add_runtime_options!

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
      empty_directory 'config'
      empty_directory 'log'
      empty_directory 'tmp/pids'

      create_file 'config/miu.god', <<-CONF
# vim: ft=ruby
require 'miu'

God.port = 30300
God.pid_file_directory = Miu.root.join('tmp/pids')

God.watch do |w|
  w.dir = Miu.root
  w.log = Miu.root.join('log/fluentd.log')
  w.name = 'fluentd'
  w.start = 'bundle exec fluentd -c config/fluent.conf'
  w.keepalive
end
      CONF
      create_file 'config/fluent.conf', <<-CONF
# built-in TCP input
# $ echo <json> | fluent-cat <tag>
<source>
  type forward
</source>
      CONF
    end
  end
end

# load built-in plugins
require 'miu/plugins'

