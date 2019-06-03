require 'rubocop/rake_task'


namespace :s99 do
  RuboCop::RakeTask.new

  desc 'run all test'
  # task :test => ['rubocop:auto_correct']  do
  task :test do
    puts 'Run tests'
    ruby 'test/*.rb'
  end
end
