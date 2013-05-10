# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miu/version'

Gem::Specification.new do |spec|
  spec.name          = 'miu'
  spec.version       = Miu::VERSION
  spec.authors       = ['mashiro']
  spec.email         = ['mail@mashiro.org']
  spec.description   = %q{Miu message hub}
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/yuijo/miu'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor', '>= 0.18.1'
  spec.add_dependency 'god', '>= 0.13.2'
  spec.add_dependency 'ffi-rzmq', '>= 1.0.0'
  spec.add_dependency 'msgpack', '>= 0.5.4'
  spec.add_development_dependency 'rake', '>= 10.0.4'
  spec.add_development_dependency 'rspec', '>= 2.13.0'
  spec.add_development_dependency 'celluloid-zmq', '>= 0.13.0'
end
