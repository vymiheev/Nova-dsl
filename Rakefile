require "bundler/gem_tasks"

task :default => :test

task :test => [:rspec, :rspec_report]

require 'rspec'
require 'rspec/core/rake_task'
desc "Run rspec unit tests "
RSpec::Core::RakeTask.new(:rspec) do |t|
  t.rspec_opts = ["-c", "-f progress"]
  t.pattern ='**/spec/**/*_spec.rb'
end

desc "Reporting rspec results to reports/rspec_report.html"
RSpec::Core::RakeTask.new(:rspec_report) do |t|
  t.rspec_opts = ["-c", "-f html", "--out reports/rspec_report.html"]
  t.pattern ='**/spec/**/*_spec.rb'
end

