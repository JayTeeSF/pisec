# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pisec/version'

Gem::Specification.new do |gem|
  gem.name          = "pisec"
  gem.version       = Pisec::VERSION
  gem.authors       = ["jayteesf"]
  gem.email         = ["buyer+jayteesf AT his-service DOT net"]
  gem.description   = %q{all rights reserved; for internal use only}
  gem.summary       = %q{Platform Independent (json based) Secure Env-var Configs}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # specify any dependencies here; for example:
  gem.add_dependency 'json'

  gem.add_development_dependency "rspec", ">= 2.13.0"
end
