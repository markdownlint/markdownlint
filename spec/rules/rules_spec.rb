require_relative "../rules_helper"

describe "rules" do
  let(:rules) { MarkdownLint::RuleSet.load_default }

  describe "MD001" do
    it "doesn't fire on normal headers" do
      doc = doc_for <<-EOF.unindent
                    # Header

                    ## Header 2

                    ### Header 3

                    # Header
                    EOF
      expect(rules["MD001"].check.call(doc)).to be_empty
    end

    it "fires on mismatched headers" do
      doc = doc_for <<-EOF.unindent
                    # Header

                    ### Header 3

                    ## Header 2

                    #### Header 4
                    EOF
      expect(rules["MD001"].check.call(doc)).to eq [3,7]
    end
  end

  describe "MD002" do
    it "doesn't fire on top level ast-style first header" do
      doc = doc_for <<-EOF.unindent
                    # Header
                    EOF
      expect(rules["MD002"].check.call(doc)).to be_nil
    end
    it "doesn't fire on top level setext-style first header" do
      doc = doc_for <<-EOF.unindent
                    Header
                    ======
                    EOF
      expect(rules["MD002"].check.call(doc)).to be_nil
    end
    it "fires on non-top level ast-style first header" do
      doc = doc_for <<-EOF.unindent
                    ## Header
                    EOF
      expect(rules["MD002"].check.call(doc)).to eq [1]
    end
    it "fires on non-top level setext-style first header" do
      doc = doc_for <<-EOF.unindent
                    Header
                    ------
                    EOF
      expect(rules["MD002"].check.call(doc)).to eq [1]
    end
  end
end
