# frozen_string_literal: true

module LlmOrchestrator
  # Memory manages conversation history and context for LLM interactions
  # Handles message storage, token limits, and context management
  class Memory
    attr_reader :messages

    def initialize
      @messages = []
      @max_tokens = 2000 # Adjust based on your needs
    end

    def add_message(role, content)
      @messages << { role: role, content: content }
      trim_messages if exceeds_token_limit?
    end

    def clear
      @messages.clear
    end

    def context_string
      @messages.map { |msg| "#{msg[:role]}: #{msg[:content]}" }.join("\n")
    end

    private

    def exceeds_token_limit?
      # Simple approximation: 4 chars ~= 1 token
      total_chars = @messages.sum { |msg| msg[:content].length }
      (total_chars / 4) > @max_tokens
    end

    def trim_messages
      while exceeds_token_limit? && @messages.size > 1
        @messages.shift # Remove oldest message
      end
    end
  end
end
