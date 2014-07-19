require 'mixlib/config'

module MarkdownLint
  module Config
    extend Mixlib::Config

    default :style, "default"
  end
end
