require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc "Run all examples"
RSpec::Core::RakeTask.new('spec')

task :default => :spec

require 'cane/rake_task'

desc "Run cane to check quality metrics"
Cane::RakeTask.new(:quality) do |cane|
  cane.abc_max  = 10
end
