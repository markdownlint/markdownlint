docs do |id, description|
  url_hash = [id.downcase,
              description.downcase.gsub(/[^a-z]+/, '-')].join('---')
  "https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md##{url_hash}"
end

rule 'MD001', 'Header levels should only increment by one level at a time' do
  tags :headers
  aliases 'header-increment'
  check do |doc|
    headers = doc.find_type(:header)
    old_level = nil
    errors = []
    headers.each do |h|
      errors << h[:location] if old_level && (h[:level] > old_level + 1)
      old_level = h[:level]
    end
    errors
  end
end

rule 'MD002', 'First header should be a top level header' do
  tags :headers
  aliases 'first-header-h1'
  params :level => 1
  check do |doc|
    first_header = doc.find_type(:header).first
    if first_header && (first_header[:level] != @params[:level])
      [first_header[:location]]
    end
  end
end

rule 'MD003', 'Header style' do
  # Header styles are things like ### and adding underscores
  # See https://daringfireball.net/projects/markdown/syntax#header
  tags :headers
  aliases 'header-style'
  # :style can be one of :consistent, :atx, :atx_closed, :setext
  params :style => :consistent
  check do |doc|
    headers = doc.find_type_elements(:header, false)
    if headers.empty?
      nil
    else
      doc_style = if @params[:style] == :consistent
                    doc.header_style(headers.first)
                  else
                    @params[:style]
                  end
      if doc_style == :setext_with_atx
        headers.map do |h|
          doc.element_linenumber(h) \
                      unless (doc.header_style(h) == :setext) || \
                             ((doc.header_style(h) == :atx) && \
                              (h.options[:level] > 2))
        end.compact
      else
        headers.map do |h|
          doc.element_linenumber(h) \
                      if doc.header_style(h) != doc_style
        end.compact
      end
    end
  end
end

rule 'MD004', 'Unordered list style' do
  tags :bullet, :ul
  aliases 'ul-style'
  # :style can be one of :consistent, :asterisk, :plus, :dash, :sublist
  params :style => :consistent
  check do |doc|
    bullets = doc.find_type_elements(:ul).map do |l|
      doc.find_type_elements(:li, false, l.children)
    end.flatten
    if bullets.empty?
      nil
    else
      doc_style = case @params[:style]
                  when :consistent
                    doc.list_style(bullets.first)
                  when :sublist
                    {}
                  else
                    @params[:style]
                  end
      results = []
      bullets.each do |b|
        if @params[:style] == :sublist
          level = b.options[:element_level]
          if doc_style[level]
            if doc_style[level] != doc.list_style(b)
              results << doc.element_linenumber(b)
            end
          else
            doc_style[level] = doc.list_style(b)
          end
        elsif doc.list_style(b) != doc_style
          results << doc.element_linenumber(b)
        end
      end
      results.compact
    end
  end
end

rule 'MD005', 'Inconsistent indentation for list items at the same level' do
  tags :bullet, :ul, :indentation
  aliases 'list-indent'
  check do |doc|
    bullets = doc.find_type(:li)
    errors = []
    indent_levels = []
    bullets.each do |b|
      indent_level = doc.indent_for(doc.element_line(b))
      if indent_levels[b[:element_level]].nil?
        indent_levels[b[:element_level]] = indent_level
      end
      if indent_level != indent_levels[b[:element_level]]
        errors << doc.element_linenumber(b)
      end
    end
    errors
  end
end

rule 'MD006', 'Consider starting bulleted lists at the beginning of the line' do
  # Starting at the beginning of the line means that indentation for each
  # bullet level can be identical.
  tags :bullet, :ul, :indentation
  aliases 'ul-start-left'
  check do |doc|
    doc.find_type(:ul, false).reject do |e|
      doc.indent_for(doc.element_line(e)) == 0
    end.map { |e| e[:location] }
  end
end

rule 'MD007', 'Unordered list indentation' do
  tags :bullet, :ul, :indentation
  aliases 'ul-indent'
  # Do not default to < 3, see PR#373 or the comments in RULES.md
  params :indent => 3
  check do |doc|
    errors = []
    indents = doc.find_type(:ul).map do |e|
      [doc.indent_for(doc.element_line(e)), doc.element_linenumber(e)]
    end
    curr_indent = indents[0][0] unless indents.empty?
    indents.each do |indent, linenum|
      if (indent > curr_indent) && (indent - curr_indent != @params[:indent])
        errors << linenum
      end
      curr_indent = indent
    end
    errors
  end
end

rule 'MD009', 'Trailing spaces' do
  tags :whitespace
  aliases 'no-trailing-spaces'
  params :br_spaces => 2
  check do |doc|
    errors = doc.matching_lines(/\s$/)
    if params[:br_spaces] > 1
      errors -= doc.matching_lines(/\S\s{#{params[:br_spaces]}}$/)
    end
    errors
  end
end

rule 'MD010', 'Hard tabs' do
  tags :whitespace, :hard_tab
  aliases 'no-hard-tabs'
  params :ignore_code_blocks => false
  check do |doc|
    # Every line in the document that is part of a code block. Blank lines
    # inside of a code block are acceptable.
    codeblock_lines = doc.find_type_elements(:codeblock).map do |e|
      (doc.element_linenumber(e)..
               doc.element_linenumber(e) + e.value.lines.count).to_a
    end.flatten

    # Check for lines with hard tab
    hard_tab_lines = doc.matching_lines(/\t/)
    # Remove lines with hard tabs, if they stem from codeblock
    hard_tab_lines -= codeblock_lines if params[:ignore_code_blocks]
    hard_tab_lines
  end
end

rule 'MD011', 'Reversed link syntax' do
  tags :links
  aliases 'no-reversed-links'
  check do |doc|
    doc.matching_text_element_lines(/\([^)]+\)\[[^\]]+\]/)
  end
end

rule 'MD012', 'Multiple consecutive blank lines' do
  tags :whitespace, :blank_lines
  aliases 'no-multiple-blanks'
  check do |doc|
    # Every line in the document that is part of a code block. Blank lines
    # inside of a code block are acceptable.
    codeblock_lines = doc.find_type_elements(:codeblock).map do |e|
      (doc.element_linenumber(e)..
               doc.element_linenumber(e) + e.value.lines.count).to_a
    end.flatten
    blank_lines = doc.matching_lines(/^\s*$/)
    cons_blank_lines = blank_lines.each_cons(2).select do |p, n|
                         n - p == 1
                       end.map { |_p, n| n }
    cons_blank_lines - codeblock_lines
  end
end

rule 'MD013', 'Line length' do
  tags :line_length
  aliases 'line-length'
  params :line_length => 80, :ignore_code_blocks => false, :code_blocks => true,
         :tables => true

  check do |doc|
    # Every line in the document that is part of a code block.
    codeblock_lines = doc.find_type_elements(:codeblock).map do |e|
      (doc.element_linenumber(e)..
               doc.element_linenumber(e) + e.value.lines.count).to_a
    end.flatten
    # Every line in the document that is part of a table.
    locations = doc.elements
                   .map { |e| [e.options[:location], e] }
                   .reject { |l, _| l.nil? }
    table_lines = locations.map.with_index do |(l, e), i|
      if e.type == :table
        if i + 1 < locations.size
          (l..locations[i + 1].first - 1).to_a
        else
          (l..doc.lines.count).to_a
        end
      end
    end.flatten
    overlines = doc.matching_lines(/^.{#{@params[:line_length]}}.*\s/)
    if !params[:code_blocks] || params[:ignore_code_blocks]
      overlines -= codeblock_lines
      unless params[:code_blocks]
        warn 'MD013 warning: Parameter :code_blocks is deprecated.'
        warn '  Please replace \":code_blocks => false\" by '\
             '\":ignore_code_blocks => true\" in your configuration.'
      end
    end
    overlines -= table_lines unless params[:tables]
    overlines
  end
end

rule 'MD014', 'Dollar signs used before commands without showing output' do
  tags :code
  aliases 'commands-show-output'
  check do |doc|
    doc.find_type_elements(:codeblock).select do |e|
      !e.value.empty? &&
        !e.value.split(/\n+/).map { |l| l.match(/^\$\s/) }.include?(nil)
    end.map { |e| doc.element_linenumber(e) }
  end
end

rule 'MD018', 'No space after hash on atx style header' do
  tags :headers, :atx, :spaces
  aliases 'no-missing-space-atx'
  check do |doc|
    doc.find_type_elements(:header).select do |h|
      doc.header_style(h) == :atx && doc.element_line(h).match(/^#+[^#\s]/)
    end.map { |h| doc.element_linenumber(h) }
  end
end

rule 'MD019', 'Multiple spaces after hash on atx style header' do
  tags :headers, :atx, :spaces
  aliases 'no-multiple-space-atx'
  check do |doc|
    doc.find_type_elements(:header).select do |h|
      doc.header_style(h) == :atx && doc.element_line(h).match(/^#+\s\s/)
    end.map { |h| doc.element_linenumber(h) }
  end
end

rule 'MD020', 'No space inside hashes on closed atx style header' do
  tags :headers, :atx_closed, :spaces
  aliases 'no-missing-space-closed-atx'
  check do |doc|
    doc.find_type_elements(:header).select do |h|
      doc.header_style(h) == :atx_closed \
        && (doc.element_line(h).match(/^#+[^#\s]/) \
             || doc.element_line(h).match(/[^#\s\\]#+$/))
    end.map { |h| doc.element_linenumber(h) }
  end
end

rule 'MD021', 'Multiple spaces inside hashes on closed atx style header' do
  tags :headers, :atx_closed, :spaces
  aliases 'no-multiple-space-closed-atx'
  check do |doc|
    doc.find_type_elements(:header).select do |h|
      doc.header_style(h) == :atx_closed \
        && (doc.element_line(h).match(/^#+\s\s/) \
             || doc.element_line(h).match(/\s\s#+$/))
    end.map { |h| doc.element_linenumber(h) }
  end
end

rule 'MD022', 'Headers should be surrounded by blank lines' do
  tags :headers, :blank_lines
  aliases 'blanks-around-headers'
  check do |doc|
    errors = []
    doc.find_type_elements(:header, false).each do |h|
      header_bad = false
      linenum = doc.element_linenumber(h)
      # Check previous line
      header_bad = true if (linenum > 1) && !doc.lines[linenum - 2].empty?
      # Check next line
      next_line_idx = doc.header_style(h) == :setext ? linenum + 1 : linenum
      next_line = doc.lines[next_line_idx]
      header_bad = true if !next_line.nil? && !next_line.empty?
      errors << linenum if header_bad
    end
    # Kramdown requires that headers start on a block boundary, so in most
    # cases it won't pick up a header without a blank line before it. We need
    # to check regular text and pick out headers ourselves too
    doc.find_type_elements(:p, false).each do |p|
      linenum = doc.element_linenumber(p)
      text = p.children.select { |e| e.type == :text }.map(&:value).join
      lines = text.split("\n")
      prev_lines = ['', '']
      lines.each do |line|
        # First look for ATX style headers without blank lines before
        errors << linenum if line.match(/^\#{1,6}/) && !prev_lines[1].empty?
        # Next, look for setext style
        if line.match(/^(-+|=+)\s*$/) && !prev_lines[0].empty?
          errors << (linenum - 1)
        end
        linenum += 1
        prev_lines << line
        prev_lines.shift
      end
    end
    errors.sort
  end
end

rule 'MD023', 'Headers must start at the beginning of the line' do
  tags :headers, :spaces
  aliases 'header-start-left'
  check do |doc|
    errors = []
    # The only type of header with spaces actually parsed as such is setext
    # style where only the text is indented. We check for that first.
    doc.find_type_elements(:header, false).each do |h|
      errors << doc.element_linenumber(h) if doc.element_line(h).match(/^\s/)
    end
    # Next we have to look for things that aren't parsed as headers because
    # they start with spaces.
    doc.find_type_elements(:p, false).each do |p|
      linenum = doc.element_linenumber(p)
      lines = doc.extract_text(p)
      prev_line = ''
      lines.each do |line|
        # First look for ATX style headers
        errors << linenum if line.match(/^\s+\#{1,6}/)
        # Next, look for setext style
        if line.match(/^\s+(-+|=+)\s*$/) && !prev_line.empty?
          errors << (linenum - 1)
        end
        linenum += 1
        prev_line = line
      end
    end
    errors.sort
  end
end

rule 'MD024', 'Multiple headers with the same content' do
  tags :headers
  aliases 'no-duplicate-header'
  params :allow_different_nesting => false
  check do |doc|
    headers = doc.find_type(:header)
    allow_different_nesting = params[:allow_different_nesting]

    duplicates = headers.select do |h|
      headers.any? do |e|
        e[:location] < h[:location] &&
          e[:raw_text] == h[:raw_text] &&
          (allow_different_nesting == false || e[:level] != h[:level])
      end
    end.to_set

    if allow_different_nesting
      same_nesting_duplicates = Set.new
      stack = []
      current_level = 0
      doc.find_type(:header).each do |header|
        level = header[:level]
        text = header[:raw_text]

        if current_level > level
          stack.pop
        elsif current_level < level
          stack.push([text])
        elsif stack.last.include?(text)
          same_nesting_duplicates.add(header)
        end

        current_level = level
      end

      duplicates += same_nesting_duplicates
    end

    duplicates.map { |h| doc.element_linenumber(h) }
  end
end

rule 'MD025', 'Multiple top level headers in the same document' do
  tags :headers
  aliases 'single-h1'
  params :level => 1
  check do |doc|
    headers = doc.find_type(:header, false).select do |h|
      h[:level] == params[:level]
    end
    if !headers.empty? && (doc.element_linenumber(headers[0]) == 1)
      headers[1..].map { |h| doc.element_linenumber(h) }
    end
  end
end

rule 'MD026', 'Trailing punctuation in header' do
  tags :headers
  aliases 'no-trailing-punctuation'
  params :punctuation => '.,;:!?'
  check do |doc|
    doc.find_type(:header).select do |h|
      h[:raw_text].match(/[#{params[:punctuation]}]$/)
    end.map do |h|
      doc.element_linenumber(h)
    end
  end
end

rule 'MD027', 'Multiple spaces after blockquote symbol' do
  tags :blockquote, :whitespace, :indentation
  aliases 'no-multiple-space-blockquote'
  check do |doc|
    errors = []
    doc.find_type_elements(:blockquote).each do |e|
      linenum = doc.element_linenumber(e)
      lines = doc.extract_as_text(e)
      # Handle first line specially as whitespace is stripped from the text
      # element
      errors << linenum if doc.element_line(e).match(/^\s*>  /)
      lines.each do |line|
        errors << linenum if line.start_with?(' ')
        linenum += 1
      end
    end
    errors
  end
end

rule 'MD028', 'Blank line inside blockquote' do
  tags :blockquote, :whitespace
  aliases 'no-blanks-blockquote'
  check do |doc|
    def check_blockquote(errors, elements)
      prev = [nil, nil, nil]
      elements.each do |e|
        prev.shift
        prev << e.type
        if prev == %i{blockquote blank blockquote}
          # The current location is the start of the second blockquote, so the
          # line before will be a blank line in between the two, or at least the
          # lowest blank line if there are more than one.
          errors << (e.options[:location] - 1)
        end
        check_blockquote(errors, e.children)
      end
    end
    errors = []
    check_blockquote(errors, doc.elements)
    errors
  end
end

rule 'MD029', 'Ordered list item prefix' do
  tags :ol
  aliases 'ol-prefix'
  # Style can be :one or :ordered
  params :style => :one
  check do |doc|
    case params[:style]
    when :ordered
      doc.find_type_elements(:ol).map do |l|
        doc.find_type_elements(:li, false, l.children)
           .map.with_index do |i, idx|
          unless doc.element_line(i).strip.start_with?("#{idx + 1}. ")
            doc.element_linenumber(i)
          end
        end
      end.flatten.compact
    when :one
      doc.find_type_elements(:ol).map do |l|
        doc.find_type_elements(:li, false, l.children)
      end.flatten.map do |i|
        unless doc.element_line(i).strip.start_with?('1. ')
          doc.element_linenumber(i)
        end
      end.compact
    end
  end
end

rule 'MD030', 'Spaces after list markers' do
  tags :ol, :ul, :whitespace
  aliases 'list-marker-space'
  params :ul_single => 1, :ol_single => 1, :ul_multi => 1, :ol_multi => 1
  check do |doc|
    errors = []
    doc.find_type_elements(%i{ul ol}).each do |l|
      list_type = l.type.to_s
      items = doc.find_type_elements(:li, false, l.children)
      # The entire list is to use the multi-paragraph spacing rule if any of
      # the items in it have multiple paragraphs/other block items.
      srule = items.map { |i| i.children.length }.max > 1 ? 'multi' : 'single'
      items.each do |i|
        line = doc.element_line(i)
        # See #278 - sometimes we think non-printable characters are list
        # items even if they are not, so this ignore those and prevents
        # us from crashing
        next if line.empty?

        actual_spaces = line.gsub(/^> /, '').match(/^\s*\S+(\s+)/)[1].length
        required_spaces = params["#{list_type}_#{srule}".to_sym]
        errors << doc.element_linenumber(i) if required_spaces != actual_spaces
      end
    end
    errors
  end
end

rule 'MD031', 'Fenced code blocks should be surrounded by blank lines' do
  tags :code, :blank_lines
  aliases 'blanks-around-fences'
  check do |doc|
    errors = []
    # Some parsers (including kramdown) have trouble detecting fenced code
    # blocks without surrounding whitespace, so examine the lines directly.
    in_code = false
    fence = nil
    lines = [''] + doc.lines + ['']
    lines.each_with_index do |line, linenum|
      line.strip.match(/^(`{3,}|~{3,})/)
      unless Regexp.last_match(1) &&
             (
               !in_code ||
               (Regexp.last_match(1).slice(0, fence.length) == fence)
             )
        next
      end

      fence = in_code ? nil : Regexp.last_match(1)
      in_code = !in_code
      if (in_code && !lines[linenum - 1].empty?) ||
         (!in_code && !lines[linenum + 1].empty?)
        errors << linenum
      end
    end
    errors
  end
end

rule 'MD032', 'Lists should be surrounded by blank lines' do
  tags :bullet, :ul, :ol, :blank_lines
  aliases 'blanks-around-lists'
  check do |doc|
    errors = []
    # Some parsers (including kramdown) have trouble detecting lists
    # without surrounding whitespace, so examine the lines directly.
    in_list = false
    in_code = false
    fence = nil
    prev_line = ''
    doc.lines.each_with_index do |line, linenum|
      next if line.strip == '{:toc}'

      unless in_code
        list_marker = line.strip.match(/^([*+\-]|(\d+\.))\s/)
        if list_marker && !in_list && !prev_line.match(/^($|\s)/)
          errors << (linenum + 1)
        elsif !list_marker && in_list && !line.match(/^($|\s)/)
          errors << linenum
        end
        in_list = list_marker
      end
      line.strip.match(/^(`{3,}|~{3,})/)
      if Regexp.last_match(1) && (
          !in_code || (Regexp.last_match(1).slice(0, fence.length) == fence)
        )
        fence = in_code ? nil : Regexp.last_match(1)
        in_code = !in_code
        in_list = false
      end
      prev_line = line
    end
    errors.uniq
  end
end

rule 'MD033', 'Inline HTML' do
  tags :html
  aliases 'no-inline-html'
  params :allowed_elements => ''
  check do |doc|
    doc.element_linenumbers(doc.find_type(:html_element))
    allowed = params[:allowed_elements].delete(" \t\r\n").downcase.split(',')
    errors = doc.find_type_elements(:html_element).reject do |e|
      allowed.include?(e.value)
    end
    doc.element_linenumbers(errors)
  end
end

rule 'MD034', 'Bare URL used' do
  tags :links, :url
  aliases 'no-bare-urls'
  check do |doc|
    doc.matching_text_element_lines(%r{https?://})
  end
end

rule 'MD035', 'Horizontal rule style' do
  tags :hr
  aliases 'hr-style'
  params :style => :consistent
  check do |doc|
    hrs = doc.find_type(:hr)
    if hrs.empty?
      []
    else
      doc_style = if params[:style] == :consistent
                    doc.element_line(hrs[0])
                  else
                    params[:style]
                  end
      doc.element_linenumbers(
        hrs.reject { |e| doc.element_line(e) == doc_style },
      )
    end
  end
end

rule 'MD036', 'Emphasis used instead of a header' do
  tags :headers, :emphasis
  aliases 'no-emphasis-as-header'
  params :punctuation => '.,;:!?'
  check do |doc|
    # We are looking for a paragraph consisting entirely of emphasized
    # (italic/bold) text.
    errors = []
    doc.find_type_elements(:p, false).each do |p|
      next if p.children.length > 1
      next unless %i{em strong}.include?(p.children[0].type)

      lines = doc.extract_text(p.children[0], '', false)
      next if lines.length > 1
      next if lines.empty?
      next if lines[0].match(/[#{params[:punctuation]}]$/)

      errors << doc.element_linenumber(p)
    end
    errors
  end
end

rule 'MD037', 'Spaces inside emphasis markers' do
  tags :whitespace, :emphasis
  aliases 'no-space-in-emphasis'
  check do |doc|
    # Kramdown doesn't parse emphasis with spaces, which means we can just
    # look for emphasis patterns inside regular text with spaces just inside
    # them.
    (doc.matching_text_element_lines(/\s(\*\*?|__?)\s.+\1/) | \
      doc.matching_text_element_lines(/(\*\*?|__?).+\s\1\s/)).sort
  end
end

rule 'MD038', 'Spaces inside code span elements' do
  tags :whitespace, :code
  aliases 'no-space-in-code'
  check do |doc|
    # We only want to check single line codespan elements and not fenced code
    # block that happen to be parsed as code spans.
    doc.element_linenumbers(
      doc.find_type_elements(:codespan).select do |i|
        i.value.match(/(^\s|\s$)/) && !i.value.include?("\n")
      end,
    )
  end
end

rule 'MD039', 'Spaces inside link text' do
  tags :whitespace, :links
  aliases 'no-space-in-links'
  check do |doc|
    doc.element_linenumbers(
      doc.find_type_elements(:a).reject { |e| e.children.empty? }.select do |e|
        e.children.first.type == :text && e.children.last.type == :text && (
          e.children.first.value.start_with?(' ') ||
          e.children.last.value.end_with?(' '))
      end,
    )
  end
end

rule 'MD040', 'Fenced code blocks should have a language specified' do
  tags :code, :language
  aliases 'fenced-code-language'
  check do |doc|
    # Kramdown parses code blocks with language settings as code blocks with
    # the class attribute set to language-languagename.
    doc.element_linenumbers(doc.find_type_elements(:codeblock).select do |i|
                              !i.attr['class'].to_s.start_with?('language-') &&
                                !doc.element_line(i).start_with?('    ')
                            end)
  end
end

rule 'MD041', 'First line in file should be a top level header' do
  tags :headers
  aliases 'first-line-h1'
  params :level => 1
  check do |doc|
    first_header = doc.find_type(:header).first
    [1] if first_header.nil? || (first_header[:location] != 1) \
      || (first_header[:level] != params[:level])
  end
end

rule 'MD046', 'Code block style' do
  tags :code
  aliases 'code-block-style'
  params :style => :fenced
  check do |doc|
    style = @params[:style]
    doc.element_linenumbers(
      doc.find_type_elements(:codeblock).select do |i|
        # for consistent we determine the first one
        if style == :consistent
          style = if doc.element_line(i).start_with?('    ')
                    :indented
                  else
                    :fenced
                  end
        end
        if style == :fenced
          # if our parent is a list or a codeblock, we need to ignore
          # its spaces, plus 4 more
          parent = i.options[:parent]
          ignored_spaces = 0
          if parent
            parent.options.delete(:children)
            parent.options.delete(:parent)
            if %i{li codeblock}.include?(parent.type)
              linenum = doc.element_linenumbers([parent]).first
              indent = doc.indent_for(doc.lines[linenum - 1])
              ignored_spaces = indent + 4
            end
          end
          start = ' ' * ignored_spaces
          doc.element_line(i).start_with?("#{start}    ")
        else
          !doc.element_line(i).start_with?('    ')
        end
      end,
    )
  end
end

rule 'MD047', 'File should end with a single newline character' do
  tags :blank_lines
  aliases 'single-trailing-newline'
  check do |doc|
    error_lines = []
    last_line = doc.lines[-1]
    error_lines.push(doc.lines.length) unless last_line.nil? || last_line.empty?
    error_lines
  end
end

rule 'MD055', 'Table row doesn\'t begin/end with pipes' do
  tags :tables
  aliases 'table-rows-start-and-end-with-pipes'
  check do |doc|
    error_lines = []
    tables = doc.find_type_elements(:table)
    lines = doc.lines

    tables.each do |table|
      table_pos = table.options[:location] - 1
      table_rows = get_table_rows(lines, table_pos)

      table_rows.each_with_index do |line, index|
        if line.length < 2 || line[0] != '|' || line[-1] != '|'
          error_lines << (table_pos + index + 1)
        end
      end
    end

    error_lines
  end
end

rule 'MD056', 'Table has inconsistent number of columns' do
  tags :tables
  aliases 'inconsistent-columns-in-table'
  check do |doc|
    error_lines = []
    tables = doc.find_type_elements(:table)
    lines = doc.lines

    tables.each do |table|
      table_pos = table.options[:location] - 1
      table_rows = get_table_rows(lines, table_pos)

      num_headings = number_of_columns_in_a_table_row(lines[table_pos])

      table_rows.each_with_index do |line, index|
        if number_of_columns_in_a_table_row(line) != num_headings
          error_lines << (table_pos + index + 1)
        end
      end
    end

    error_lines
  end
end

rule 'MD057', 'Table has missing or invalid header separation (second row)' do
  tags :tables
  aliases 'table-invalid-second-row'
  check do |doc|
    error_lines = []
    tables = doc.find_type_elements(:table)
    lines = doc.lines

    tables.each do |table|
      second_row = ''

      # line number of table start (1-indexed)
      # which is equal to second row's index (0-indexed)
      line_num = table.options[:location]
      second_row = lines[line_num] if line_num < lines.length

      # This pattern matches if
      #   1) The row starts and stops with | characters
      #   2) Only consists of characters '|', '-', ':' and whitespace
      #   3) Each section between the separators (i.e. '|')
      #      a) has at least three consecutive dashes
      #      b) can have whitespace at the beginning or the end
      #      c) can have colon before and/or after dashes (for alignment)
      #   Some examples:
      #       |-----|----|-------|      --> matches
      #       |:---:|:---|-------|      --> matches
      #       |  :------:  | ----|      --> matches
      #       | - - - | - - - |         --> does NOT match
      #       |::---|                   --> does NOT match
      #       |----:|:--|----|          --> does NOT match
      pattern = /^(\|\s*:?-{3,}:?\s*)+\|$/
      unless second_row.match(pattern)
        # Second row is not in the form described by the pattern
        error_lines << (line_num + 1)
      end
    end

    error_lines
  end
end
