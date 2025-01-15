# frozen_string_literal: true

require_relative "lib/llm_orchestrator/version"

Gem::Specification.new do |spec|
  spec.name = "llm_orchestrator"
  spec.version = LlmOrchestrator::VERSION
  spec.authors = ["@aquaflamingo"]
  spec.email = ["aquaflamingo@nitrousmail.com"]

  spec.summary = "A lightweight ruby framework for orchestrating operations via LLM APIs"
  spec.description = "A simple and flexible framework for managing prompts and LLM interactions with OpenAI and Anthropic Claude"
  spec.homepage = "https://github.com/aquaflamingo/llm_orchestrator"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.glob("{lib}/**/*") + %w[README.md LICENSE.txt CHANGELOG.md]
  spec.require_paths = ["lib"]

  spec.add_dependency "anthropic", "~> 0.3.2"
  spec.add_dependency "ruby-openai", "~> 6.0"

  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "vcr", "~> 6.1"
  spec.add_development_dependency "webmock", "~> 3.18"
end
