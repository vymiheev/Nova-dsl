require "bundler/gem_tasks"


task :default => :test

task :test => :rspec

require 'rspec'
require 'rspec/core/rake_task'
desc "Run rspec unit tests "
RSpec::Core::RakeTask.new(:rspec) do |t|
  t.rspec_opts = ["-c", "-f progress"]
  t.pattern ='**/spec/**/*_spec.rb'
end