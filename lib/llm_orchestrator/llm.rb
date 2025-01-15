require 'openai'
require 'anthropic'

module LlmOrchestrator
  class LLM
    def initialize(api_key: nil)
      @api_key = api_key || LlmOrchestrator.configuration.api_key
    end
    
    def generate(prompt, context: nil, **options)
      raise NotImplementedError, "Subclasses must implement generate method"
    end
  end
  
  class OpenAILLM < LLM
    def initialize(api_key: nil)
      super
      @client = OpenAI::Client.new(access_token: @api_key)
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

  class ClaudeLLM < LLM
    def initialize(api_key: nil)
      super
      @client = Anthropic::Client.new(api_key: @api_key)
    end

    def generate(prompt, context: nil, **options)
      system_prompt = context ? "#{context}\n\n" : ""
      
      response = @client.messages.create(
        model: options[:model] || 'claude-3-opus-20240229',
        messages: [
          {
            role: 'user',
            content: system_prompt + prompt
          }
        ],
        temperature: options[:temperature] || 0.7
      )
      
      response.content.first.text
    end
  end
end