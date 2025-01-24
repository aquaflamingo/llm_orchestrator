# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

desc "Build and publish the gem"
task :publish do
  require_relative "lib/llm_orchestrator/version"
  version = LlmOrchestrator::VERSION
  system "gem build *.gemspec"
  gem_file = "llm_orchestrator-#{version}.gem"
  system "gem push #{gem_file}"
end

task :default => :validate
