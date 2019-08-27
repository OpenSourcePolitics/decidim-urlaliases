# frozen_string_literal: true

require "decidim/dev"

ENV["ENGINE_ROOT"] = File.dirname(__dir__)

Decidim::Dev.dummy_app_path = File.expand_path(File.join(__dir__, "decidim_dummy_app"))

require "decidim/dev/test/base_spec_helper"

require "database_cleaner"

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.after(:each, type: :feature) do
    DatabaseCleaner.clean_with :truncation, except: %w(ar_internal_metadata)
    Capybara.reset_sessions! # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end
end
