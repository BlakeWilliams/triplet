# frozen_string_literal: true

require "view_component"

module Triplet
  module ViewComponent
    include Triplet::DSL
    alias_method :template_tag, :template

    def self.included(klass)
      klass.define_method(:call) do
        render_triplet(template)
      end
    end
  end
end
