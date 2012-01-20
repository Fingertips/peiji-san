source "http://rubygems.org"

group :development do
  gem "minitest", :require => %w( minitest/spec minitest/autorun )
  gem "mocha"
  # If you have a problem on OSX with sqlite3 extension not linking right (), use this
  #    $bundle config build.sqlite3 --with-sqlite3-include=/usr/local/include --with-sqlite3-lib=/usr/local/lib
  # where the includes and lib paths match your system settings
  gem 'sqlite3'
  gem "rails", "3.1", :require => %w( active_support active_record action_view )
  gem "jeweler"
  gem "rake"
  
  # Testing with sinatra
  gem "sinatra", :require => "sinatra/base"
  
  # There needs to be a new release for this
  gem "tobias-sinatra-url-for", :require => 'sinatra/url_for'
  
  gem 'rack-test'
end
