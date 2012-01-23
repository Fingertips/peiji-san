# -*- encoding: utf-8 -*-
require File.expand_path("../lib/peiji_san/version", __FILE__)

Gem::Specification.new do |s|
  s.name     = "peiji-san"
  s.version  = PeijiSan::VERSION
  s.date     = Date.today

  s.homepage = "http://github.com/Fingertips/peiji-san"
  s.summary  = "PeijiSan is a Rails plugin which uses named scopes to create a thin pagination layer."
  s.authors  = ["Eloy Duran"]
  s.email    = "eloy.de.enige@gmail.com"

  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]

  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "init.rb",
    "lib/peiji_san.rb",
    "lib/peiji_san/view_helper.rb",
    "test/peiji_san_test.rb",
    "test/sinatra_test.rb",
    "test/test_helper.rb",
    "test/view_helper_test.rb"
  ]

  s.require_paths = ["lib"]

  s.add_development_dependency "minitest"
  s.add_development_dependency "mocha"
  s.add_development_dependency "rake"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "rdoc"

  # Rails
  s.add_development_dependency "activesupport", ">= 3.1"
  s.add_development_dependency "activerecord",  ">= 3.1"
  s.add_development_dependency "actionpack",    ">= 3.1"
  # If you have a problem on OSX with sqlite3 extension not linking right (), use this
  #    $bundle config build.sqlite3 --with-sqlite3-include=/usr/local/include --with-sqlite3-lib=/usr/local/lib
  # where the includes and lib paths match your system settings
  s.add_development_dependency "sqlite3"

  # Sinatra
  s.add_development_dependency "sinatra"
  # There needs to be a new release for this
  s.add_development_dependency "tobias-sinatra-url-for"
end

