# frozen_string_literal: true

require "test_helper"

module Triplet
  class TemplateTest < Minitest::Test
    def test_basic_template
      template = Template.new do
        h1(class: "font-xl") {
          "world"
        }
      end

      assert_equal '<h1 class="font-xl">world</h1>', template.to_s
    end

    def test_works_with_html_safe
      template = Template.new do
        h1('data-attribute': "{'foo'}".html_safe) {
          "world"
        }
      end

      assert_equal '<h1 data-attribute="{\'foo\'}">world</h1>', template.to_s
    end

    def test_works_with_values_outside_of_block
      title = "world"

      template = Template.new do
        h1('data-attribute': "{'foo'}".html_safe) {
          title
        }
      end

      assert_equal '<h1 data-attribute="{\'foo\'}">world</h1>', template.to_s
    end

    def test_works_with_nested_tags
      template = Template.new do
        h1('data-attribute': "{'foo'}".html_safe) {[
          a(href: "/home") {[ span { "My App" } ]}
        ]}
      end

      assert_equal '<h1 data-attribute="{\'foo\'}"><a href="/home"><span>My App</span></a></h1>', template.to_s
    end

    def test_works_with_multiple_lines
      template = Template.new do
        h1('data-attribute': "{'foo'}".html_safe) {[
          a(href: "/home") {[
            span { "My App" }
          ]},
          "tagline"
        ]}
      end

      assert_equal '<h1 data-attribute="{\'foo\'}"><a href="/home"><span>My App</span></a>tagline</h1>', template.to_s
    end

    def test_works_with_mixing_syntax
      template = Template.new do
        h1('data-attribute': "{'foo'}".html_safe) {[
          [:a, { href: "/home" }, [span { "My App" }]],
          "tagline"
        ]}
      end

      assert_equal '<h1 data-attribute="{\'foo\'}"><a href="/home"><span>My App</span></a>tagline</h1>', template.to_s
    end

    def test_works_with_method_composition
      renderer = Class.new do
        include Triplet::DSL

        def initialize(nav_items)
          @nav_items = nav_items
          @output_buffer = ActionView::OutputBuffer.new
        end

        def to_s
          render_triplet nav {[
            @nav_items.map do |title, url|
              nav_item(url) {[
                b { title }
              ]}
            end
          ]}
        end

        def nav_item(url, &block)
          a(href: url.html_safe, class: "text-xl mr-3", &block)
        end
      end

      result = renderer.new("Home": "/", "Pricing": "/pricing").to_s
      expected = '<nav><a href="/" class="text-xl mr-3"><b>Home</b></a><a href="/pricing" class="text-xl mr-3"><b>Pricing</b></a></nav>'
      assert_equal expected, result
    end
  end
end
