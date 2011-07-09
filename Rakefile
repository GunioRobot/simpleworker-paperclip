# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "simpleworker-paperclip"
  gem.homepage = "http://github.com/poptart/simpleworker-paperclip"
  gem.license = "MIT"
  gem.summary = %Q{SimpleWorker <=> Paperclip linker}
  gem.description = %Q{Gluecode for SimpleWorker and Paperclip, designed for zero configuration at the SimpleWorker side}
  gem.email = "luke@appoxy.com"
  gem.authors = ["Luke Carpenter"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task :default => :test

require 'yard'
YARD::Rake::YardocTask.new
