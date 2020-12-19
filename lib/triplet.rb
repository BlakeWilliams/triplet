# frozen_string_literal: true

require "action_view" # Necessary for output buffer

require "triplet/version"
require "triplet/dsl"
require "triplet/template"

module Triplet
  class Error < StandardError; end

  def self.template(&block)
    Template.new(&block).to_s
  end
end
