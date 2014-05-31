#!/usr/bin/env ruby
# Quick script for viewing getting at kramdown's view of a markdown file
require 'kramdown'
require 'pry'

doc = Kramdown::Document.new(File.read(ARGV[0]))
children = doc.root.children

binding.pry
