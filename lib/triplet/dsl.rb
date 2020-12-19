# frozen_string_literal: true

module Triplet
  module DSL
    include ActionView::Helpers::CaptureHelper
    include ActionView::Helpers::TagHelper

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
        [
          tag,
          attrs,
          block&.call,
        ]
      end
    end

    def render_triplet(triplet)
      if triplet.is_a?(String)
        triplet
      elsif triplet.is_a?(Array)
        # If the array size is 3 and the first object is a
        # symbol, it's likely a renderable triplet
        if triplet.length == 3 && triplet[0].is_a?(Symbol)
          tag, attrs, children = triplet

          content_tag(tag, attrs) do
            if children.is_a?(Array)
              safe_join(children.map { |c| render_triplet(c) }, "")
            else
              render_triplet(children)
            end
          end
        else
          safe_join(triplet.map { |c| render_triplet(c) }, "")
        end
      else
        triplet.to_s
      end
    end

    private

    attr_accessor :output_buffer

    # Override capture to support triplets
    def capture(*args)
      value = nil
      buffer = with_output_buffer { value = yield(*args) }
      if (string = buffer.presence || value) && string.is_a?(String)
        ERB::Util.html_escape string
      elsif value.is_a?(Array) # This is the only change, adds triplet support
        render_triplet(value)
      end
    end
  end
end
