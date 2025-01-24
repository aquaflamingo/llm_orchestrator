# frozen_string_literal: true

require "bundler/setup"
require "llm_orchestrator"
require "vcr"
require "pry"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<OPENAI_API_KEY>") { ENV["OPENAI_API_KEY"] }
  config.filter_sensitive_data("<CLAUDE_API_KEY>") { ENV["CLAUDE_API_KEY"] }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Configure LlmOrchestrator with test credentials
  LlmOrchestrator.configure do |config|
    # OpenAI configuration
    config.openai.api_key = ENV["OPENAI_API_KEY"]
    config.openai.model = "gpt-3.5-turbo"
    config.openai.temperature = 0.7
    config.openai.max_tokens = 1000

    # Claude configuration
    config.claude.api_key = ENV["CLAUDE_API_KEY"]
    config.claude.model = "claude-3-opus-20240229"
    config.claude.temperature = 0.7
    config.claude.max_tokens = 1000
  end
end
