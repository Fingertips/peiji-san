# Fix for those annoying issues when using an older system rake
module Rake
  module DSL
  end
end

require 'rubygems'
require 'bundler'
Bundler.require

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'PeijiSan'
  rdoc.options << '--line-numbers' << '--inline-source' << '--charset=utf-8'
  rdoc.rdoc_files.include('README*', 'LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = false
end

task :default => :test
