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
  spec.homepage = 'https://github.com/markdownlint/markdownlint'
  spec.license = 'MIT'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = %w{LICENSE.txt Gemfile} + Dir.glob('*.gemspec') +
               Dir.glob('lib/**/*')
  spec.bindir = 'bin'
  spec.executables = %w{mdl}
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.2'

  spec.add_dependency 'kramdown', '~> 2.3'
  spec.add_dependency 'kramdown-parser-gfm', '~> 1.1'
  spec.add_dependency 'mixlib-cli'
  spec.add_dependency 'mixlib-config'
  spec.add_dependency 'mixlib-shellout'
end
