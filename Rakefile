require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name     = "peiji-san"
    gem.homepage = "http://github.com/Fingertips/peiji-san"
    gem.email    = "eloy.de.enige@gmail.com"
    gem.authors  = ["Eloy Duran"]
    gem.summary = gem.description = "PeijiSan is a Rails plugin which uses named scopes to create a thin pagination layer."
  end
  
  begin
    require 'jewelry_portfolio/tasks'
    JewelryPortfolio::Tasks.new do |p|
      p.account = 'Fingertips'
    end
  rescue LoadError
    puts "JewelryPortfolio not available. Install it with: sudo gem install Fingertips-jewelry_portfolio -s http://gems.github.com"
  end
  
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/rdoctask'
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
