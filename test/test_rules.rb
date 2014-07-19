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
      # Heading 1 {MD016} {MD017}

      ## Heading 2 {MD016} {MD017}

      # Heading 3 {MD016} {MD017}
    ),
    'headers_bad' => %(
      # Header {MD016} {MD017}

      ### Header 3 {MD001} {MD016} {MD017}

      ## Header 2 {MD016} {MD017}

      #### Header 4 {MD001} {MD016} {MD017}
    ),
    'first_header_good_atx' => %(
      # Header {MD016} {MD017}
    ),
    'first_header_good_setext' => %(
      Header {MD015} {MD016}
      ======
    ),
    'first_header_bad_atx' => %(
      ## Header {MD002} {MD016} {MD017}
    ),
    'first_header_bad_setext' => %(
      Header {MD002} {MD015} {MD016}
      ----------------
    ),
    'mixed_header_types_atx' => %(
      # Header {MD016} {MD017}

      ## Header 2 {MD003} {MD015} {MD017} ##

      Header 3 {MD003} {MD015} {MD016}
      ----------------
    ),
    'mixed_header_types_atx_closed' => %(
      # Header 1 {MD015} {MD017} #

      ## Header 2 {MD003} {MD016} {MD017}

      Header 3 {MD003} {MD015} {MD016}
      ----------------
    ),
    'mixed_header_types_setext' => %(
      Header 1 {MD015} {MD016}
      ======

      ## Header 2 {MD003} {MD016} {MD017}

      ## Header 3 {MD003} {MD015} {MD017} ##
    ),
    'atx_header_spacing' => %(
      #Header 1 {MD018} {MD016} {MD017}

      ##  Header 2 {MD019} {MD016} {MD017}

      ##   Header 3 {MD019} {MD016} {MD017}
    ),
    'atx_closed_header_spacing' => %(
      #Header 1 {MD020} {MD015} {MD017} #

      # Header 2 {MD020} {MD015} {MD017}#

      #Header 3 {MD020} {MD015} {MD017}#

      #  Header 4 {MD021} {MD015} {MD017} #

      # Header 5 {MD021} {MD015} {MD017}  #

      #  Header 6 {MD021} {MD015} {MD017}  #

      #   Header 7 {MD021} {MD015} {MD017}   #
    ),
    'headers_surrounding_space_atx' => %(
      # Header 1 {MD016} {MD017}

      # Header 2 {MD022} {MD016} {MD017}
      Some text
      # Header 3 {MD022}
      Some text
      # Header 4 {MD022}

      # Header 5 {MD016} {MD017}
    ),
    'headers_surrounding_space_setext' => %(
      Header 1 {MD015} {MD016}
      ========================

      Header 2 {MD022} {MD015} {MD016}
      ================================
      Some text
      Header 3 {MD022}
      ================
      Some text
      Header 4 {MD022}
      ================
      Some text

      Header 5 {MD015} {MD016}
      ========================
    ),
    'headers_with_spaces_at_the_beginning' => %(
      Some text

       # Header 1 {MD023}

       Setext style fully indented {MD023}
       ===================================

       Setext style title only indented {MD023} {MD015} {MD016}
      =========================================================
    ),
    'header_duplicate_content' => %(
      # Header 1 {MD016} {MD017}

      # Header 2 {MD016} {MD017}

      # Header 1 {MD016} {MD017}

      ## Header 2 {MD016} {MD017}

      # Header 3 {MD016} {MD017}

      {MD024:5} {MD024:7}
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
    ),
    'code_block_dollar' => %(
      The following code block shouldn't have $ before the commands:

          $ ls {MD014}
          $ less foo

          $ cat bar

      However the following code block shows output, and $ can be used to
      distinguish between command and output:

          $ ls
          foo bar
          $ less foo
          Hello world

          $ cat bar
          baz
    )
  }

  testcases.each do |title, text|
    define_method("test_#{title}") do
      do_lint(text)
    end
  end
end
