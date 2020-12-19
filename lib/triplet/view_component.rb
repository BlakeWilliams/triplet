# frozen_string_literal: true

require "view_component"

module Triplet
  module ViewComponent
    include Triplet::DSL

    def render_in(view_context, &block)
      @output_buffer ||= ActionView::OutputBuffer.new
      super(view_context, &block)
    end
  end
end
