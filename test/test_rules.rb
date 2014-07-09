require_relative 'setup_tests'

class String
  def unindent
    # Removes indentation from heredoc entries
    gsub(/^#{scan(/^\s*/).min_by{|l|l.length}}/, "")
  end
end

class TestRules < Minitest::Test

  def setup
    @rules = MarkdownLint::RuleSet.load_default
  end

  def get_expected_errors(lines)
    # Looks for lines tagged with {MD123} to signify that a rule is expected to
    # fire for this line. It also looks for lines tagged with {MD123:1} to
    # signify that a rule is expected to fire on another line (the line number
    # after the colon).
    expected_errors = {}
    re = /\{(MD\d+)(?::(\d+))?\}/
    lines.each_with_index do |line, num|
      m = re.match(line)
      while m
        expected_errors[m[1]] ||= []
        if m[2]
          expected_line = m[2].to_i
        else
          expected_line = num + 1 # 1 indexed lines
        end
        expected_errors[m[1]] << expected_line
        m = re.match(line, m.end(0))
      end
    end
    expected_errors
  end

  def do_lint(text)
    # Fixup indented text inside %( and )
    text = text.sub(/^\s*\n/, '').rstrip.unindent
    doc = MarkdownLint::Doc.new(text)
    expected_errors = get_expected_errors(doc.lines)
    actual_errors = {}
    @rules.sort.each do |id, rule|
      error_lines = rule.check.call(doc)
      if error_lines and not error_lines.empty?
        actual_errors[id] = error_lines
      end
    end
    assert_equal expected_errors, actual_errors
  end

  testcases = {
    'empty_doc' => "",
    'headers_good' => %(
      # Heading 1

      ## Heading 2

      # Heading 3
    ),
    'headers_bad' => %(
      # Header

      ### {MD001} Header 3

      ## Header 2

      #### {MD001} Header 4
    ),
    'first_header_good_ast' => %(
      # Header
    ),
    'first_header_good_setext' => %(
      Header
      ======
    ),
    'first_header_bad_ast' => %(
      ## Header {MD002}
    ),
    'first_header_bad_setext' => %(
      Header {MD002}
      ----------------
    ),
    'mixed_header_types_ast' => %(
      # Header

      ## Header {MD003} ##

      Header {MD003}
      ----------------
    ),
    'mixed_header_types_ast_closed' => %(
      # Header #

      ## Header {MD003}

      Header {MD003}
      ----------------
    ),
    'mixed_header_types_setext' => %(
      Header
      ======

      ## Header {MD003}

      ## Header {MD003} ##
    ),
    'consistent_bullet_styles_asterisk' => %(
      * Item
        * Item {MD007}
        * Item
    ),
    'consistent_bullet_styles_plus' => %(
      + Item
        + Item {MD007}
        + Item
    ),
    'consistent_bullet_styles_dash' => %(
      - Item
        - Item {MD007}
        - Item
    ),
    'inconsistent_bullet_styles_asterisk' => %(
      * Item
        + Item {MD004} {MD007}
        - Item {MD004}
    ),
    'inconsistent_bullet_styles_plus' => %(
      + Item
        * Item {MD004} {MD007}
        - Item {MD004}
    ),
    'inconsistent_bullet_styles_dash' => %(
      - Item
        * Item {MD004} {MD007}
        + Item {MD004}
    ),
    'inconsistent_bullet_indent_same_level' => %(
      * Item
          * Item {MD008}
        * Item {MD005}
          * Item
    ),
    'bulleted_list_not_at_beginning_of_line' => %(
      Some text

        * Item {MD006}
          * Item {MD007}
          * Item
            * Item {MD007}
          * Item
        * Item
        * Item

      Some more text

        * Item {MD006}
          * Item {MD007}
    ),
    'bulleted_list_4_space_indent' => %(
      * Test X
          * Test Y {MD008}
              * Test Z {MD008}
    ),
    'whitespace issues' => %(
      Some text {MD009} 
      Some	more text {MD010}
      Some more text
    ),
    'reversed_link' => %(
      Go to (this website)[http://www.example.com] {MD011}
    ),
    'consecutive_blank_lines' => %(
      Some text


      Some text {MD012:3}

          This is a code block


          with two blank lines in it

      Some more text
    ),
    'long_lines' => %(
      This is a very very very very very very very very very very very very very very long line {MD013}

      This line however, while very long, doesn't have whitespace after the 80th columnwhichallowsforURLsandotherlongthings.
    )
  }

  testcases.each do |title, text|
    define_method("test_#{title}") do
      do_lint(text)
    end
  end
end
