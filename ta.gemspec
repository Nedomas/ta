# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ta/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nedomas"]
  gem.email         = ["domas.bitvinskas@me.com"]
  gem.description   = %q{Technical analysis gem.}
  gem.summary       = %q{Technical analysis gem.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ta"
  gem.require_paths = ["lib"]
  gem.version       = Ta::VERSION
end
