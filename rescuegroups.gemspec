# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rescuegroups/version'

Gem::Specification.new do |spec|
  spec.name          = "rescuegroups"
  spec.version       = Rescuegroups::VERSION
  spec.authors       = ["bornfree"]
  spec.email         = ["harsha.xg@gmail.com"]
  spec.description   = "Ruby client for Rescuegroups API"
  spec.summary       = "Same as above"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "curb"
  spec.add_development_dependency "json"
  spec.add_development_dependency "pry-rails"
end
