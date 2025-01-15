# frozen_string_literal: true

require "spec_helper"

RSpec.describe LlmOrchestrator::Memory do
  let(:memory) { described_class.new }

  describe "#add_message" do
    it "adds a message to the collection" do
      memory.add_message("user", "Hello")
      expect(memory.messages).to include(role: "user", content: "Hello")
    end

    it "trims messages when exceeding token limit" do
      # Add messages that exceed the token limit
      50.times { memory.add_message("user", "x" * 200) }
      expect(memory.messages.size).to be < 50
    end
  end

  describe "#clear" do
    it "removes all messages" do
      memory.add_message("user", "Hello")
      memory.clear
      expect(memory.messages).to be_empty
    end
  end

  describe "#context_string" do
    it "formats messages as a string" do
      memory.add_message("user", "Hello")
      memory.add_message("assistant", "Hi")
      expect(memory.context_string).to eq("user: Hello\nassistant: Hi")
    end
  end
end
