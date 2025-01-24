# frozen_string_literal: true

require "spec_helper"

# rubocop:disable Metrics/BlockLength
RSpec.describe LlmOrchestrator::LLM do
  before do
    LlmOrchestrator.configure do |config|
      config.openai.api_key = "test-openai-key"
      config.openai.model = "gpt-3.5-turbo"
      config.openai.temperature = 0.7
      config.openai.max_tokens = 1000

      config.claude.api_key = "test-claude-key"
      config.claude.model = "claude-3-opus-20240229"
      config.claude.temperature = 0.7
      config.claude.max_tokens = 1000
    end
  end

  describe LlmOrchestrator::OpenAI do
    let(:llm) { described_class.new }

    describe "#initialize" do
      it "uses configuration defaults" do
        expect(llm.instance_variable_get(:@api_key)).to eq("test-openai-key")
        expect(llm.instance_variable_get(:@model)).to eq("gpt-3.5-turbo")
        expect(llm.instance_variable_get(:@temperature)).to eq(0.7)
        expect(llm.instance_variable_get(:@max_tokens)).to eq(1000)
      end

      it "allows overriding defaults" do
        custom_llm = described_class.new(
          api_key: "custom-key",
          model: "gpt-4",
          temperature: 0.5,
          max_tokens: 2000
        )

        expect(custom_llm.instance_variable_get(:@api_key)).to eq("custom-key")
        expect(custom_llm.instance_variable_get(:@model)).to eq("gpt-4")
        expect(custom_llm.instance_variable_get(:@temperature)).to eq(0.5)
        expect(custom_llm.instance_variable_get(:@max_tokens)).to eq(2000)
      end
    end

    describe "#generate" do
      it "generates text using OpenAI API" do
        VCR.use_cassette("openai_generate") do
          response = llm.generate("Say hello")
          expect(response).to be_a(String)
          expect(response).not_to be_empty
        end
      end

      it "includes context when provided" do
        VCR.use_cassette("openai_generate_with_context") do
          response = llm.generate("Continue the conversation", context: "We were discussing AI")
          expect(response).to be_a(String)
          expect(response).not_to be_empty
        end
      end
    end
  end

  describe LlmOrchestrator::Anthropic do
    let(:llm) { described_class.new }

    describe "#initialize" do
      it "uses configuration defaults" do
        expect(llm.instance_variable_get(:@api_key)).to eq("test-claude-key")
        expect(llm.instance_variable_get(:@model)).to eq("claude-3-opus-20240229")
        expect(llm.instance_variable_get(:@temperature)).to eq(0.7)
        expect(llm.instance_variable_get(:@max_tokens)).to eq(1000)
      end

      it "allows overriding defaults" do
        custom_llm = described_class.new(
          api_key: "custom-key",
          model: "claude-3-sonnet-20240229",
          temperature: 0.5,
          max_tokens: 2000
        )

        expect(custom_llm.instance_variable_get(:@api_key)).to eq("custom-key")
        expect(custom_llm.instance_variable_get(:@model)).to eq("claude-3-sonnet-20240229")
        expect(custom_llm.instance_variable_get(:@temperature)).to eq(0.5)
        expect(custom_llm.instance_variable_get(:@max_tokens)).to eq(2000)
      end
    end

    describe "#generate" do
      it "generates text using Claude API" do
        VCR.use_cassette("claude_generate") do
          response = llm.generate("Say hello")
          expect(response).to be_a(String)
          expect(response).not_to be_empty
        end
      end

      it "includes context when provided" do
        VCR.use_cassette("claude_generate_with_context") do
          response = llm.generate("Continue the conversation", context: "We were discussing AI")
          expect(response).to be_a(String)
          expect(response).not_to be_empty
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
