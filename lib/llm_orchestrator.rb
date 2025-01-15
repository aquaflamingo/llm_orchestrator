# frozen_string_literal: true

require_relative "llm_orchestrator/version"
require_relative "llm_orchestrator/prompt"
require_relative "llm_orchestrator/chain"
require_relative "llm_orchestrator/llm"
require_relative "llm_orchestrator/memory"

module LlmOrchestrator
  class Error < StandardError; end
  
  class << self
    attr_accessor :configuration
    
    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end
  end
  
  class Configuration
    attr_accessor :default_llm_provider, :openai_api_key, :claude_api_key
    
    def initialize
      @default_llm_provider = :openai
      @openai_api_key = nil
      @claude_api_key = nil
    end

    def api_key
      case default_llm_provider
      when :openai
        openai_api_key
      when :claude
        claude_api_key
      end
    end
  end
end
