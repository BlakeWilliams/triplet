# frozen_string_literal: true

require "view_component"

module Triplet
  module ViewComponent
    include Triplet::DSL

    def self.included(klass)
      klass.define_method(:call) do
        @output_buffer ||= ActionView::OutputBuffer.new
        template
      end
    end

    def template
      raise "#template method not implemented"
    end
  end
end
