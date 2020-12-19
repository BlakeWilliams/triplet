# frozen_string_literal: true

require "test_helper"
require "rails"
require "action_pack"
require "view_component"
require "triplet/view_component"
require "action_controller/railtie"

class ApplicationController < ActionController::Base
end

module Triplet
  class ViewComponentTest < Minitest::Test
    include ::ViewComponent::TestHelpers
    include Capybara::Minitest::Assertions


    class MyViewComponent < ::ViewComponent::Base
      include Triplet::ViewComponent

      def template
        h1 { "hello world" }
      end
    end

    class MyNestedComponent < ::ViewComponent::Base
      include Triplet::ViewComponent

      def template
        div do
          render MyViewComponent.new
        end
      end
    end

    def test_basic_view_component
      render_inline MyViewComponent.new

      assert_selector "h1", text: "hello world"
    end

    def test_nested_view_component
      render_inline MyNestedComponent.new

      assert_selector "div" do 
        assert_selector "h1", text: "hello world"
      end
    end

    def controller
      @_controller ||= ApplicationController.new
    end
  end
end
