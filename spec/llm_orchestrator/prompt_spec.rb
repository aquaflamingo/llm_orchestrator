require 'spec_helper'

RSpec.describe LlmOrchestrator::Prompt do
  let(:template) { "Hello {name}, how are you {time_of_day}?" }
  let(:prompt) { described_class.new(template) }

  describe '#initialize' do
    it 'extracts variables from the template' do
      expect(prompt.variables).to contain_exactly(:name, :time_of_day)
    end
  end

  describe '#format' do
    it 'replaces variables with provided values' do
      result = prompt.format(name: 'John', time_of_day: 'morning')
      expect(result).to eq('Hello John, how are you morning?')
    end

    it 'handles missing variables' do
      result = prompt.format(name: 'John')
      expect(result).to eq('Hello John, how are you {time_of_day}?')
    end
  end
end