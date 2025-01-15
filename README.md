# LlmOrchestrator

A lightweight Ruby framework for orchestrating LLM operations with OpenAI and Anthropic Claude. This gem provides a simple way to:

- Manage prompt templates
- Chain LLM operations
- Maintain conversation context
- Switch between OpenAI and Claude providers

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'llm_orchestrator'
```

And then execute:

```bash
$ bundle install
```

## Configuration

Configure your API keys:

```ruby
LlmOrchestrator.configure do |config|
  config.openai_api_key = ENV['OPENAI_API_KEY']
  config.claude_api_key = ENV['CLAUDE_API_KEY']
  config.default_llm_provider = :claude  # or :openai
end
```

## Basic Usage

### Prompt Templates

```ruby
# Create and use a prompt template
prompt = LlmOrchestrator::Prompt.new("Answer this {type} question: {question}")
formatted = prompt.format(
  type: "math",
  question: "What is 2+2?"
)
```

### LLM Providers

```ruby
# Using OpenAI
openai = LlmOrchestrator::OpenAI.new
response = openai.generate("What is 2+2?", model: "gpt-3.5-turbo")

# Using Claude
claude = LlmOrchestrator::Anthropic.new
response = claude.generate("What is 2+2?", model: "claude-3-opus-20240229")
```

### Chains with Memory

```ruby
# Create a chain with memory
memory = LlmOrchestrator::Memory.new
chain = LlmOrchestrator::Chain.new(memory: memory)

# Add processing steps
chain.add_step do |input, memory|
  llm = LlmOrchestrator::Anthropic.new
  llm.generate(input, context: memory.context_string)
end

# Run multiple interactions with context
result1 = chain.run("What is the capital of France?")
result2 = chain.run("What is its population?") # Uses previous context

# Clear memory when needed
chain.clear_memory
```

## Development

After checking out the repo, run:

```bash
$ bundle install
$ bundle exec rspec
```

The tests use VCR to record HTTP interactions. To run the tests with real API calls:

1. Set up your environment variables:
```bash
export OPENAI_API_KEY="your-key-here"
export CLAUDE_API_KEY="your-key-here"
```

2. Delete the VCR cassettes (if they exist):
```bash
rm -rf spec/fixtures/vcr_cassettes
```

3. Run the tests:
```bash
bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/llm_orchestrator.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
