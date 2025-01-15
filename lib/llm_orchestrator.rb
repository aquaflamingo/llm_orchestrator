# frozen_string_literal: true

require_relative "llm_orchestrator/version"
require_relative "llm_orchestrator/prompt"
require_relative "llm_orchestrator/chain"
require_relative "llm_orchestrator/llm"
require_relative "llm_orchestrator/memory"

# LlmOrchestrator is a framework for managing interactions with Large Language Models (LLMs).
# It provides a unified interface for working with different LLM providers like OpenAI and Anthropic.
module LlmOrchestrator
  class Error < StandardError; end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end
  end

  # Configuration class for LlmOrchestrator
  # Manages global settings like API keys and default LLM provider
  class Configuration
    attr_accessor :default_llm_provider, :openai_api_key, :claude_api_key

    def initialize
      @default_llm_provider = :openai
      @openai_api_key = nil
      @claude_api_key = nil
    end
  end
end
