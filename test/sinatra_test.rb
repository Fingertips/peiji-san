# -*- encoding : utf-8 -*-
require File.expand_path('../test_helper', __FILE__)
require 'rack/test'

class SimplisticApp < Sinatra::Base
  helpers Sinatra::UrlForHelper, PeijiSan::ViewHelper
  include Mocha::API
  
  enable :raise_errors
  
  get '/' do
    collection = stub('Artists paginated collection')
    collection.stubs(:current_page?).with(1).returns(false)
    collection.stubs(:current_page?).with(2).returns(false)
    collection.stubs(:page_count).returns(125)
    link_to_page(2, collection)
  end
end

ENV['RACK_ENV'] = 'test'

describe "A Sinatra app that uses Peiji-San" do
  include Rack::Test::Methods
  
  def app
    SimplisticApp
  end
  
  it "has it's helper module put in place" do
    get '/'
    last_response.status.must_equal 200
    last_response.body.must_equal '<a href="&#x2F;?page=2&amp;anchor=">2</a>'
  end
end

