require 'spec_helper'

RSpec.describe LlmOrchestrator::Chain do
  let(:memory) { LlmOrchestrator::Memory.new }
  let(:chain) { described_class.new(memory: memory) }

  describe '#add_step' do
    it 'adds a step to the chain' do
      chain.add_step { |input| input.upcase }
      expect(chain.run('hello')).to eq('HELLO')
    end

    it 'returns self for chaining' do
      expect(chain.add_step { |input| input }).to eq(chain)
    end
  end

  describe '#run' do
    it 'executes steps in sequence' do
      chain
        .add_step { |input| input.upcase }
        .add_step { |input| "#{input}!" }

      expect(chain.run('hello')).to eq('HELLO!')
    end

    it 'passes memory to steps' do
      chain.add_step { |input, mem| mem.add_message('user', input); input }
      chain.run('hello')
      expect(memory.messages).to include(role: 'user', content: 'hello')
    end
  end

  describe '#clear_memory' do
    it 'clears the memory' do
      chain.add_step { |input, mem| mem.add_message('user', input); input }
      chain.run('hello')
      chain.clear_memory
      expect(memory.messages).to be_empty
    end
  end
end