# frozen_string_literal: true

require "llm_orchestrator"
require "vcr"
require "webmock/rspec"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<OPENAI_API_KEY>") { ENV["OPENAI_API_KEY"] }
  config.filter_sensitive_data("<CLAUDE_API_KEY>") { ENV["CLAUDE_API_KEY"] }
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

LlmOrchestrator.configure do |config|
  config.openai_api_key = ENV["OPENAI_API_KEY"]
  config.claude_api_key = ENV["CLAUDE_API_KEY"]
end
