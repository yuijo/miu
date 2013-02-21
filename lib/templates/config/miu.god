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
