# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'obfuscurity/version'

Gem::Specification.new do |gem|
  gem.name          = "obfuscurity"
  gem.version       = Obfuscurity::VERSION
  gem.authors       = ["Graham Ashton"]
  gem.email         = ["graham@effectif.com"]
  gem.description   = <<-EOF
Sometimes exposing your app's internal counters (e.g. your database's
auto-incrementing primary keys) to the world is a bad idea. Maybe your
competitors will be able to work out how many orders you're making per
week, or your customers will be able to infer how many other customers
you've got. This gem will allow you to obscure those numbers so you can
use them in your URLs, your user interface, or as seemingly random order
numbers.
  EOF
  gem.summary       = %q{Obfuscate your database ids, converting them to (seemingly) random numbers}
  gem.homepage      = "https://github.com/gma/obfuscurity"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('nutrasuite')
  gem.add_development_dependency('rake')
end
