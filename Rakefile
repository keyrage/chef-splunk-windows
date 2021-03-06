require 'rspec/core/rake_task'
require 'foodcritic'
require 'kitchen'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any']
    }
  end
end

desc 'Run all style checks'
task style: ['style:chef']

desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = './**/unit/**/*_spec.rb'
end

desc 'Run Test Kitchen'
task :integration do
  Kitchen.logger = Kitchen.default_file_logger
  Kitchen::Config.new.instances.each do |instance|
    instance.test(:always)
  end
end

# Default
task default: %w(style unit integration)

task lint: %w(style unit integration)