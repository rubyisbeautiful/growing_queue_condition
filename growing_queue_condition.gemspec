# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'growing_queue_condition/version'

Gem::Specification.new do |spec|
  spec.name          = 'growing_queue_condition'
  spec.version       = GrowingQueueCondition::VERSION
  spec.authors       = ['rubyisbeautiful']
  spec.email         = ['bcptaylor@gmail.com']
  spec.description   = %q{a God::Condition for the god gem, which will alert on a neglected queue using any object/method}
  spec.summary       = %q{a God::Condition for the god gem, which will alert on a neglected queue}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'

  spec.add_runtime_dependency 'god'
end
