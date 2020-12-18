# frozen_string_literal: true

require "action_view" # Necessary for output buffer

require "triplet/version"
require "triplet/template"
require "triplet/dsl"

module Triplet
  class Error < StandardError; end

  def self.template(&block)
    Template.new.run(&block)
  end
end
