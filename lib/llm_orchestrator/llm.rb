# frozen_string_literal: true

require "openai"
require "anthropic"

module LlmOrchestrator
  # Base class for LLM providers
  # Defines the interface that all LLM implementations must follow
  class LLM
    def initialize(api_key: nil, model: nil, temperature: nil, max_tokens: nil)
      @api_key = api_key
      @model = model
      @temperature = temperature
      @max_tokens = max_tokens
    end

    def generate(prompt, context: nil, **options)
      raise NotImplementedError, "Subclasses must implement generate method"
    end
  end

  # OpenAI LLM provider implementation
  # Handles interactions with OpenAI's GPT models
  class OpenAI < LLM
    def initialize(api_key: nil, model: nil, temperature: nil, max_tokens: nil)
      super
      @api_key ||= LlmOrchestrator.configuration.openai.api_key
      @client = ::OpenAI::Client.new(access_token: @api_key)
      @model = model || LlmOrchestrator.configuration.openai.model
      @temperature = temperature || LlmOrchestrator.configuration.openai.temperature
      @max_tokens = max_tokens || LlmOrchestrator.configuration.openai.max_tokens 
    end

    # rubocop:disable Metrics/MethodLength
    def generate(prompt, context: nil, **options)
      messages = []
      messages << { role: "system", content: context } if context
      messages << { role: "user", content: prompt }

      response = @client.chat(
        parameters: {
          model: options[:model] || @model,
          messages: messages,
          temperature: options[:temperature] || @temperature
        }
      )

      response.dig("choices", 0, "message", "content")
    end
    # rubocop:enable Metrics/MethodLength
  end

  # Anthropic LLM provider implementation
  # Handles interactions with Anthropic's Claude models
  class Anthropic < LLM
    def initialize(api_key: nil, model: nil, temperature: nil, max_tokens: nil)
      super
      @api_key ||= LlmOrchestrator.configuration.claude.api_key
      @client = ::Anthropic::Client.new(access_token: @api_key)
      @model = model || LlmOrchestrator.configuration.claude.model
      @temperature = temperature || LlmOrchestrator.configuration.claude.temperature
      @max_tokens = max_tokens || LlmOrchestrator.configuration.claude.max_tokens
    end

    # rubocop:disable Metrics/MethodLength
    def generate(prompt, context: nil, **options)
      response = @client.messages(
        parameters: {
          model: options[:model] || @model,
          system: context,
          messages: [
            { role: "user", content: prompt }
          ],
          temperature: options[:temperature] || @temperature,
          max_tokens: options[:max_tokens] || @max_tokens
        }
      )

      response.content.first.text
    end
    # rubocop:enable Metrics/MethodLength
  end
end
