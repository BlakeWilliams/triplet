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
        h1 {
          "hello world"
        }
      end
    end

    class MyNestedComponent < ::ViewComponent::Base
      include Triplet::ViewComponent

      def template
        div {
          render MyViewComponent.new
        }
      end
    end

    class User
      include ActiveModel::Model
      attr_accessor :email
    end

    class FormComponent < ::ViewComponent::Base
      include Triplet::ViewComponent

      def template
        h1('foo': 'bar') {[
          "sign up for ", b { "my app" },
          form_for(User.new, url: "foo") {|f| [
            f.text_field(:email, placeholder: "placholder"),
          ]},
        ]}
      end
    end

    class TemplateTagComponent < ::ViewComponent::Base
      include Triplet::ViewComponent

      def template
        template_tag(class: "js-hello") {[
          "hello <% my placeholder %>"
        ]}
      end
    end

    def test_template_tag_is_available
      # Use result directly, otherwise <template> tag is stripped
      result = render_inline TemplateTagComponent.new

      refute_empty result.css("template[class='js-hello']")
    end

    def test_form_component
      render_inline FormComponent.new

      assert_selector "h1", text: /sign up for my app/
      assert_selector "form[action='foo'] > input[type='text']"
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

    def request
      @request ||= controller.request
    end
  end
end
