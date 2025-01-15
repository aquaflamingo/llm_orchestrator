# frozen_string_literal: true

require "openai"
require "anthropic"
require "pry"

module LlmOrchestrator
  # Base class for LLM providers
  # Defines the interface that all LLM implementations must follow
  class LLM
    def initialize(api_key: nil)
      @api_key = api_key
    end

    def generate(prompt, context: nil, **options)
      raise NotImplementedError, "Subclasses must implement generate method"
    end
  end

  # OpenAI LLM provider implementation
  # Handles interactions with OpenAI's GPT models
  class OpenAI < LLM
    def initialize(api_key: nil)
      super
      @api_key ||= LlmOrchestrator.configuration.openai_api_key
      @client = ::OpenAI::Client.new(access_token: @api_key)
    end

    # rubocop:disable Metrics/MethodLength
    def generate(prompt, context: nil, **options)
      messages = []
      messages << { role: "system", content: context } if context
      messages << { role: "user", content: prompt }

      response = @client.chat(
        parameters: {
          model: options[:model] || "gpt-3.5-turbo",
          messages: messages,
          temperature: options[:temperature] || 0.7
        }
      )

      response.dig("choices", 0, "message", "content")
    end
    # rubocop:enable Metrics/MethodLength
  end

  # Anthropic LLM provider implementation
  # Handles interactions with Anthropic's Claude models
  class Anthropic < LLM
    def initialize(api_key: nil)
      super
      @api_key ||= LlmOrchestrator.configuration.claude_api_key
      @client = ::Anthropic::Client.new(access_token: @api_key)
    end

    # rubocop:disable Metrics/MethodLength
    def generate(prompt, context: nil, **options)
      response = @client.messages(
        parameters: {
          model: options[:model] || "claude-3-opus-20240229",
          system: context,
          messages: [
            { role: "user", content: prompt }
          ],
          temperature: options[:temperature] || 0.7,
          max_tokens: options[:max_tokens] || 1000
        }
      )

      response.content.first.text
    end
    # rubocop:enable Metrics/MethodLength
  end
end
