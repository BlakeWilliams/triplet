# frozen_string_literal: true

module Triplet
  class Template
    include Triplet::DSL

    def initialize(output_buffer = ActionView::OutputBuffer.new, &block)
      @output_buffer = output_buffer

      @output_buffer << render_triplet(instance_eval(&block))
    end

    def to_s
      @output_buffer.to_s
    end
  end
end
