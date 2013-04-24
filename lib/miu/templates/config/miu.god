# coding: utf-8 vim: ft=ruby
require 'miu/dsl'

Miu.watch 'server' do |w|
  w.start = 'miu server'
  w.keepalive
end
