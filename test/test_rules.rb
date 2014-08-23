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

      ## Heading 3
    ),
    'headers_bad' => %(
      # Header

      ### Header 3 {MD001}

      ## Header 2

      #### Header 4 {MD001}
    ),
    'first_header_good_atx' => %(
      # Header
    ),
    'first_header_good_setext' => %(
      Header
      ======
    ),
    'first_header_bad_atx' => %(
      ## Header {MD002}
    ),
    'first_header_bad_setext' => %(
      Header {MD002}
      --------------
    ),
    'mixed_header_types_atx' => %(
      # Header

      ## Header 2 {MD003} ##

      Header 3 {MD003}
      ----------------
    ),
    'mixed_header_types_atx_closed' => %(
      # Header 1 #

      ## Header 2 {MD003}

      Header 3 {MD003}
      ----------------
    ),
    'mixed_header_types_setext' => %(
      Header 1
      ========

      ## Header 2 {MD003}

      ## Header 3 {MD003} ##
    ),
    'atx_header_spacing' => %(
      #Header 1 {MD018}

      ##  Header 2 {MD019}

      ##   Header 3 {MD019}
    ),
    'atx_closed_header_spacing' => %(
      #Header 1 {MD020} #

      ## Header 2 {MD020}##

      ##Header 3 {MD020}##

      ##  Header 4 {MD021} ##

      ## Header 5 {MD021}  ##

      ##  Header 6 {MD021}  ##

      ##   Header 7 {MD021}   ##
    ),
    'headers_surrounding_space_atx' => %(
      # Header 1

      ## Header 2 {MD022}
      Some text
      ## Header 3 {MD022}
      Some text
      ## Header 4 {MD022}

      ## Header 5
    ),
    'headers_surrounding_space_setext' => %(
      Header 1
      ========

      Header 2 {MD022}
      ----------------
      Some text
      Header 3 {MD022}
      ================
      Some text
      Header 4 {MD022}
      ================
      Some text

      Header 5
      --------
    ),
    'headers_with_spaces_at_the_beginning' => %(
      Some text

       # Header 1 {MD023}

       Setext style fully indented {MD023}
       ===================================

       Setext style title only indented {MD023}
      =========================================
    ),
    'header_duplicate_content' => %(
      # Header 1

      ## Header 2

      ## Header 1

      ### Header 2

      ## Header 3

      {MD024:5} {MD024:7}
    ),
    'header_multiple_toplevel' => %(
      # Heading 1

      # Heading 2 {MD025}
    ),
    'header_mutliple_h1_no_toplevel' => %(
      Some introductory text

      # Heading 1

      # Heading 2
    ),
    'header_trailing_punctuation' => %(
      # Heading 1 {MD026}.

      ## Heading 2 {MD026},

      ## Heading 3 {MD026}!

      ## Heading 4 {MD026}:

      ## Heading 5 {MD026};

      ## Heading 6 {MD026}?
    ),
    'consistent_bullet_styles_asterisk' => %(
      * Item
        * Item
        * Item
    ),
    'consistent_bullet_styles_plus' => %(
      + Item
        + Item
        + Item
    ),
    'consistent_bullet_styles_dash' => %(
      - Item
        - Item
        - Item
    ),
    'inconsistent_bullet_styles_asterisk' => %(
      * Item
        + Item {MD004}
        - Item {MD004}
    ),
    'inconsistent_bullet_styles_plus' => %(
      + Item
        * Item {MD004}
        - Item {MD004}
    ),
    'inconsistent_bullet_styles_dash' => %(
      - Item
        * Item {MD004}
        + Item {MD004}
    ),
    'inconsistent_bullet_indent_same_level' => %(
      * Item
          * Item {MD007}
        * Item {MD005}
          * Item
    ),
    'bulleted_list_not_at_beginning_of_line' => %(
      Some text

        * Item {MD006}
          * Item
          * Item
            * Item
          * Item
        * Item
        * Item

      Some more text

        * Item {MD006}
          * Item
    ),
    'bulleted_list_4_space_indent' => %(
      * Test X
          * Test Y {MD007}
              * Test Z {MD007}
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
    ),
    'blockquote_spaces' => %(
      Some text

      > Hello world
      >  Foo {MD027}
      >  Bar {MD027}

      This tests other things embedded in the blockquote:

      > *Hello world*
      >  *foo* {MD027}
      >  **bar** {MD027}
      >   "Baz" {MD027}
      > *foo*
      > **bar**
      > 'baz'

      Test the first line being indented too much:

      >  Foo {MD027}
      >  Bar {MD027}
      > Baz
    )
  }

  testcases.each do |title, text|
    define_method("test_#{title}") do
      do_lint(text)
    end
  end
end
