# frozen_string_literal: true

module Triplet
  module DSL
    TAGS = [
      :a, :abbr, :address, :area, :article, :aside, :audio,
      :b, :base, :bdi, :bdo, :blockquote, :body, :br, :button,
      :canvas, :caption, :cite, :code, :col, :colgroup,
      :data, :datalist, :dd, :del, :details, :dfn, :dialog, :div, :dl, :dt,
      :em, :embed,
      :fieldset, :figure, :footer, :form,
      :h1, :h2, :h3, :h4, :h5, :h6, :head, :header, :hgroup, :hr, :html,
      :i, :iframe, :img, :input, :ins,
      :kbd, :keygen,
      :label, :legend, :li, :link,
      :main, :map, :mark, :menu, :menuitem, :meta, :meter,
      :nav, :noscript,
      :object, :ol, :optgroup, :option, :output,
      :p, :param, :pre, :progress,
      :q,
      :rb, :rp, :rt, :rtc, :ruby,
      :s, :samp, :script, :section, :select, :small, :source, :span, :strong, :style, :sub, :summary, :sup,
      :table, :tbody, :td, :template, :textarea, :tfoot, :th, :thead, :time, :title, :tr, :track,
      :u, :ul,
      :var, :video,
      :wbr
    ].freeze
    VOID_TAGS = [:area, :base, :br, :col, :embed, :hr, :img, :input, :link, :meta, :param, :source, :track, :wbr].freeze

    # TODO handle VOID_TAGS specially
    TAGS.each do |tag|
      define_method tag do |attrs = {}, &block|
        html_tag(tag, attrs, &block)
      end
    end

    def text(text)
      @output_buffer << text
    end

    def html_tag(tag, attrs = {}, &block)
      @output_buffer.safe_concat "<#{tag}"
      @output_buffer.safe_concat " " unless attrs.empty?
      _write_attributes(attrs)
      @output_buffer.safe_concat ">"

      if block
        value = nil
        result = capture do
          value = block.call
        end

        # Supports returning a string directlycfrom blocks
        if result.length == 0 && value
          @output_buffer << value
        else
          @output_buffer << result
        end
      end

      @output_buffer.safe_concat "</#{tag}>"
    end

    private

    def _write_attributes(attrs)
      attrs.each_with_index do |(k,v), i|
        @output_buffer << k.to_s
        @output_buffer.safe_concat '="'
        @output_buffer << v.to_s
        @output_buffer.safe_concat '"'
        @output_buffer.safe_concat ' ' if i != attrs.length - 1
      end
    end

    def capture
      original_output_buffer = @output_buffer

      begin
        @output_buffer = ActionView::OutputBuffer.new
        yield
        @output_buffer
      ensure
        @output_buffer = original_output_buffer
      end
    end
  end
end

Triplet::Template.include(Triplet::DSL)
