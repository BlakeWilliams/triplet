$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "triplet"

# Fake Rails setup
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "view_component/engine"

ENV["RAILS_ENV"] ||= "test"
require_relative "./test_application/config/environment"
require "rails/test_help"

require "minitest/autorun"
require "minitest/pride"
