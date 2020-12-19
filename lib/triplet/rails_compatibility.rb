# frozen_string_literal: true
#
require "view_component"

module Triplet
  module RailsCompatibility
    VALID_SUFFIXES = ["_field", "_button", "text_area"].freeze
    VALID_METHODS = [
      "form_for",
      "form_with",
      "label",
      "fields_for",
      "fields",
    ].freeze
    include ActionView::Helpers::FormTagHelper
    include ActionView::Helpers::FormHelper

    # Override helpers to modify @output_buffer directly
    (
      ActionView::Helpers::FormTagHelper.public_instance_methods +
      ActionView::Helpers::FormHelper.public_instance_methods
    ).each do |method|
      alias_method :"original_#{method}", method
      define_method method do |*args, **kwargs, &block|
        puts "calling #{method}"
        result = public_send(:"original_#{method}", *args, **kwargs, &block)

        if result.class < String
          @output_buffer << result
        end

        nil # Necessary to prevent double renders
      end
    end
  end
end
