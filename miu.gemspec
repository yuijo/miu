# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miu/version'

Gem::Specification.new do |gem|
  gem.name          = "miu"
  gem.version       = Miu::VERSION
  gem.authors       = ["mashiro"]
  gem.email         = ["mail@mashiro.org"]
  gem.description   = %q{miu miu}
  gem.summary       = %q{miu miu}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'bundler', '>= 1.2.0'
  gem.add_dependency 'thor', '>= 0.17.0'
  gem.add_dependency 'ffi-rzmq'
  gem.add_dependency 'msgpack', '>= 0.5.3'
  gem.add_development_dependency 'rake', '>= 10.0.3'
end
