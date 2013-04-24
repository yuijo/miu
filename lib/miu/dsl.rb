require 'miu'
require 'god/sugar'
require 'god/task'
require 'god/watch'

module Miu
  class << self
    def dump_cli_options(options)
      options.map do |k, v|
        v = case v
            when Array
              v.map { |x| "'#{x}'" }.join(' ')
            else
              v.to_s
            end
        "#{k}=#{v}"
      end.join(' ')
    end

    def watch(name)
      God.watch do |w|
        w.dir = Miu.root
        w.log = Miu.root.join("log/#{name}.log").to_s
        w.name = name
        w.group = 'all'

        yield w if block_given?

        [:start, :stop, :restart].each do |action|
          value = w.public_send action
          if value.is_a?(Array)
            options = Miu::Utility.extract_options! value
            value << dump_cli_options(options)
            w.public_send "#{action}=", value.join(' ')
          end
        end
      end
    end
  end
end

if $load_god
  God.port = Miu.default_god_port
  God.pid_file_directory = Miu.root.join('tmp/pids').to_s
end
