require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:cucumber)

task :test do
  Rake::Task["cucumber"].invoke
  Rake::Task["spec"].invoke
end

task :default => :test
