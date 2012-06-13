require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

task :push do
  exec("git push -u origin master")
end

task :add do
  exec("git add .")
end

task :commit do
  exec("git commit -ae")
end
