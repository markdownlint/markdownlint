# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mdl/version'

Gem::Specification.new do |spec|
  spec.name          = "mdl"
  spec.version       = MarkdownLint::VERSION
  spec.authors       = ["Mark Harrison"]
  spec.email         = ["mark@mivok.net"]
  spec.summary       = %q{Markdown lint tool}
  spec.description   = %q{Style checker/lint tool for markdown files}
  spec.homepage      = "http://github.com/markdownlint/markdownlint"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.2'

  spec.add_dependency 'kramdown', '~> 1.12', '>= 1.12.0'
  spec.add_dependency 'mixlib-config', '~> 2.2', '>= 2.2.1'
  spec.add_dependency 'mixlib-cli', '~> 1.7', '>= 1.7.0'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 11.2'
  spec.add_development_dependency 'minitest', '~> 5.9'
  spec.add_development_dependency 'pry', '~> 0.10'
end
