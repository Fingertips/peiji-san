# -*- encoding : utf-8 -*-
require File.expand_path('../test_helper', __FILE__)
require 'rack/test'
require 'sinatra/base'
require 'sinatra/url_for'
require 'rexml/document'

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
  
  get '/something' do
    collection = stub('Articles in a subdirectory')
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
  
  def query_hash(link)
    query = REXML::Document.new(link).root.attributes['href'].match(/\?(.+)$/)[1]
    Rack::Utils.parse_query(query)
  end
  
  it "has it's link_to_page method working in subdirectories" do
    get '/something'
    last_response.status.must_equal 200
    assert_equal '<a href="&#x2F;something?page=2">2</a>', last_response.body
  end
  
  it "has it's link_to_page method put in place and operational" do
    get '/'
    last_response.status.must_equal 200
    query_hash(last_response.body).must_equal 'page' => '2'
  end
end

