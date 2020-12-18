# frozen_string_literal: true

module Triplet
  class Template
    def initialize(output_buffer = ActionView::OutputBuffer.new, &block)
      @output_buffer = output_buffer

      instance_eval(&block)
    end

    def to_s
      @output_buffer.to_s
    end
  end
end
