require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'

# Default directory to look in is `/specs`
# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'documentation']
end

YARD::Rake::YardocTask.new

task :default => :spec

