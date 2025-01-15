module LlmOrchestrator
  class Prompt
    attr_reader :template, :variables
    
    def initialize(template)
      @template = template
      @variables = extract_variables(template)
    end
    
    def format(values = {})
      result = template.dup
      values.each do |key, value|
        result.gsub!("{#{key}}", value.to_s)
      end
      result
    end
    
    private
    
    def extract_variables(template)
      template.scan(/\{(\w+)\}/).flatten.map(&:to_sym)
    end
  end
end