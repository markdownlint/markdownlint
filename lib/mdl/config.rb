require 'mixlib/config'

module MarkdownLint
  # our Mixlib::Config class
  module Config
    extend Mixlib::Config

    default :style, 'default'
  end
end
