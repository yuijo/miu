# vim: ft=ruby
require 'miu'

God.port = Miu.default_god_port
God.pid_file_directory = Miu.root.join('tmp/pids')

God.watch do |w|
  w.dir = Miu.root
  w.log = Miu.root.join('log/miu.log')
  w.name = 'miu'
  w.start = 'bundle exec miu start'
  w.keepalive
end
