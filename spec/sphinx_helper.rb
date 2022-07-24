# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  # DatabaseCleaner settings
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, sphinx: true) do
    DatabaseCleaner.strategy = :truncation
    # Index data when running an acceptance spec.
    ThinkingSphinx::Test.index
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# require 'rails_helper'
#
# # ThinkingSphinx::Deltas.resume!
#
# RSpec.configure do |config|
#   # Transactional fixtures work with real-time indices
#   config.use_transactional_fixtures = false
#
#   config.before :each do |example|
#     # Configure and start Sphinx for request specs
#     if example.metadata[:type] == :request
#       ThinkingSphinx::Test.init
#       ThinkingSphinx::Test.start index: false
#     end
#
#     # Disable real-time callbacks if Sphinx isn't running
#     ThinkingSphinx::Configuration.instance.settings['real_time_callbacks'] =
#       (example.metadata[:type] == :request)
#   end
#
#   config.after(:each) do |example|
#     # Stop Sphinx and clear out data after request specs
#     if example.metadata[:type] == :request
#       ThinkingSphinx::Test.stop
#       ThinkingSphinx::Test.clear
#     end
#   end
#
#   config.before(:each) do
#     # Default to transaction strategy for all specs
#     DatabaseCleaner.strategy = :transaction
#   end
#
#   config.before(:each, :sphinx => true) do
#     # For tests tagged with Sphinx, use deletion (or truncation)
#     DatabaseCleaner.strategy = :deletion
#   end
#
#   config.before(:each) do
#     DatabaseCleaner.start
#   end
#
#   config.append_after(:each) do
#     DatabaseCleaner.clean
#   end
# end