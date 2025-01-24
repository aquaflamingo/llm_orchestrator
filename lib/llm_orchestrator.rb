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
    attr_accessor :default_llm_provider
    
    def initialize
      @default_llm_provider = :openai
      @openai = OpenAIConfig.new
      @claude = ClaudeConfig.new
    end

    def openai
      @openai ||= OpenAIConfig.new
    end

    def claude
      @claude ||= ClaudeConfig.new
    end
  end

  # Configuration class for OpenAI-specific settings
  class OpenAIConfig
    attr_accessor :api_key, :model, :temperature, :max_tokens

    def initialize
      @api_key = nil
      @model = "gpt-3.5-turbo"
      @temperature = 0.7
      @max_tokens = 1000
    end
  end

  # Configuration class for Claude-specific settings
  class ClaudeConfig
    attr_accessor :api_key, :model, :temperature, :max_tokens

    def initialize
      @api_key = nil
      @model = "claude-3-opus-20240229"
      @temperature = 0.7
      @max_tokens = 1000
    end
  end
end
