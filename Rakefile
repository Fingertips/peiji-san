require 'rubygems'
require 'bundler'
Bundler.require(:development)

Jeweler::Tasks.new do |s|
  s.name     = "peiji-san"
  s.homepage = "http://github.com/Fingertips/peiji-san"
  s.email    = "eloy.de.enige@gmail.com"
  s.authors  = ["Eloy Duran"]
  s.summary  = s.description = "PeijiSan is a Rails plugin which uses named scopes to create a thin pagination layer."
  s.files    = FileList['**/**'] # tmp until we've patched Jeweler to be able to easily add files to defaults
end

# jewelry_portfolio is not currently available as a gem proper
# and has odd dependencies. Probably back from when github has been publishing gems.
# Could not find gem 'schacon-git', required by 'jewelry_portfolio', in any of the sources
begin
  require 'jewelry_portfolio/tasks'
  JewelryPortfolio::Tasks.new do |p|
    p.account = 'Fingertips'
  end
rescue LoadError
end

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
