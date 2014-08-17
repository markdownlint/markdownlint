#!/usr/bin/env ruby
# Script for identifying when markdownlint is receiving an incorrect line
# number for an element. It checks all headers, then grabs the lines
# associated with the headers according to markdown and compares the content,
# printing out any that don't match.
require 'mdl/doc'
require 'pry'

text = File.read(ARGV[0])
unless ARGV[1].nil?
  # If we provide a second argument, then start the document from line N of
  # the original file.
  text = text.split("\n")[ARGV[1].to_i - 1..-1].join("\n")
end
doc = MarkdownLint::Doc.new(text)
headers = doc.find_type(:header)
bad_headers = headers.select do |e|
   doc.element_line(e).nil? || ! doc.element_line(e).include?(e[:raw_text])
end
pp bad_headers
