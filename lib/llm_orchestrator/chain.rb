# frozen_string_literal: true
module LlmOrchestrator
  # Chain represents a sequence of processing steps for LLM operations
  # It allows for composing multiple LLM operations together with memory persistence
  class Chain
    def initialize(memory: nil)
      @steps = []
      @memory = memory || Memory.new
    end

    def add_step(&block)
      @steps << block
      self
    end

    def run(input)
      @steps.reduce(input) do |result, step|
        output = step.call(result, @memory)
        @memory.add_message("assistant", output) if output.is_a?(String)
        output
      end
    end

    def clear_memory
      @memory.clear
    end
  end
end
