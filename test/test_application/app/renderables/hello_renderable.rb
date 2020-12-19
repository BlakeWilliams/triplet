# frozen_string_literal: true

class HelloRenderable
  def initialize(name:)
    @name = name
  end

  def render_in(_view_context)
    "<p>Hello from #{@name}</p>"
  end
end
