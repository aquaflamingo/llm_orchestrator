require 'openai'
require 'anthropic'
require 'pry'

module LlmOrchestrator
  class LLM
    def initialize(api_key: nil)
      @api_key = api_key
    end
    
    def generate(prompt, context: nil, **options)
      raise NotImplementedError, "Subclasses must implement generate method"
    end
  end
  
  class OpenAI < LLM
    def initialize(api_key: nil)
      super
      @api_key ||= LlmOrchestrator.configuration.openai_api_key
      @client = ::OpenAI::Client.new(access_token: @api_key)
    end

    def generate(prompt, context: nil, **options)
      messages = []
      messages << { role: 'system', content: context } if context
      messages << { role: 'user', content: prompt }
      
      response = @client.chat(
        parameters: {
          model: options[:model] || 'gpt-3.5-turbo',
          messages: messages,
          temperature: options[:temperature] || 0.7
        }
      )
      
      response.dig('choices', 0, 'message', 'content')
    end
  end

  class Anthropic < LLM
    def initialize(api_key: nil)
      super
      @api_key ||= LlmOrchestrator.configuration.claude_api_key
      @client = ::Anthropic::Client.new(access_token: @api_key)
    end

    def generate(prompt, context: nil, **options)
      binding.pry
      response = @client.messages(
        parameters: {
          model: options[:model] || 'claude-3-opus-20240229',
          system: context,
          messages: [
            { role: 'user', content: prompt }
          ],
          temperature: options[:temperature] || 0.7,
          max_tokens: options[:max_tokens] || 1000
        }
      )
      
      response.content.first.text
    end
  end
end