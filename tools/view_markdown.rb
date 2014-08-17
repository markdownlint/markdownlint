#!/usr/bin/env ruby
# Quick script for viewing getting at kramdown's and markdownlint's view of a
# markdown file
require 'mdl/doc'
require 'pry'


doc = MarkdownLint::Doc.new_from_file(ARGV[0])
children = doc.parsed.root.children

binding.pry
