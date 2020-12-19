# frozen_string_literal: true

require_relative "boot"

require "rails"
require "action_controller/railtie"
require "action_view/railtie"

module Wow
  class Application < Rails::Application
    config.load_defaults 6.0
  end
end
