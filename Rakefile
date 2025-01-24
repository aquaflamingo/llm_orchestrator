# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

desc "Build and publish the gem"
task :publish do
  system "gem build *.gemspec"
  system "gem push *.gem"
end

task :default => :validate
