# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mailflow-ruby/version.rb'

Gem::Specification.new do |spec|
  spec.name          = "mailflow-ruby"
  spec.version       = Mailflow::VERSION
  spec.authors       = ["Mailflow"]
  spec.email         = ["support@mailflowhq.com"]

  spec.summary       = "The official Ruby library for Mailflow's API"
  spec.homepage      = "https://mailflowhq.com/support/api-reference"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Gems for production
  spec.add_dependency "httparty", "~> 0.13.5"
  spec.add_dependency "hashie", "~> 3.4.2"

  # Gems for dev
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "byebug"
end
