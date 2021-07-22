lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mdl/version'

Gem::Specification.new do |spec|
  spec.name = 'mdl'
  spec.version = MarkdownLint::VERSION
  spec.authors = ['Mark Harrison']
  spec.email = ['mark@mivok.net']
  spec.summary = 'Markdown lint tool'
  spec.description = 'Style checker/lint tool for markdown files'
  spec.homepage = 'http://github.com/markdownlint/markdownlint'
  spec.license = 'MIT'

  spec.files = %w{LICENSE.txt Gemfile} + Dir.glob('*.gemspec') +
               Dir.glob('lib/**/*')
  spec.bindir = 'bin'
  spec.executables = %w{mdl}
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5'

  spec.add_dependency 'kramdown', '~> 2.3'
  spec.add_dependency 'kramdown-parser-gfm', '~> 1.1'
  spec.add_dependency 'mixlib-cli', '~> 2.1', '>= 2.1.1'
  spec.add_dependency 'mixlib-config', '>= 2.2.1', '< 4'
  spec.add_dependency 'mixlib-shellout'

  spec.add_development_dependency 'bundler', '>= 1.12', '< 3'
  spec.add_development_dependency 'minitest', '~> 5.9'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rake', '>= 11.2', '< 14'
  spec.add_development_dependency 'rubocop', '>= 0.49.0'
end
