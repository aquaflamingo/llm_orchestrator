require 'spec_helper'

RSpec.describe LlmOrchestrator::LLM do
  before do
    LlmOrchestrator.configure do |config|
      config.openai_api_key = ENV['OPENAI_API_KEY']
      config.claude_api_key = ENV['CLAUDE_API_KEY']
    end
  end

  describe LlmOrchestrator::OpenAILLM do
    let(:llm) { described_class.new }

    describe '#generate' do
      it 'generates text using OpenAI API' do
        VCR.use_cassette('openai_generate') do
          response = llm.generate('Say hello')
          expect(response).to be_a(String)
          expect(response).not_to be_empty
        end
      end

      it 'includes context when provided' do
        VCR.use_cassette('openai_generate_with_context') do
          response = llm.generate('Continue the conversation', context: 'We were discussing AI')
          expect(response).to be_a(String)
          expect(response).not_to be_empty
        end
      end
    end
  end

  describe LlmOrchestrator::ClaudeLLM do
    let(:llm) { described_class.new }

    describe '#generate' do
      it 'generates text using Claude API' do
        VCR.use_cassette('claude_generate') do
          response = llm.generate('Say hello')
          expect(response).to be_a(String)
          expect(response).not_to be_empty
        end
      end

      it 'includes context when provided' do
        VCR.use_cassette('claude_generate_with_context') do
          response = llm.generate('Continue the conversation', context: 'We were discussing AI')
          expect(response).to be_a(String)
          expect(response).not_to be_empty
        end
      end
    end
  end
end