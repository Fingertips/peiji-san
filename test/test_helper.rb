# -*- encoding : utf-8 -*-

module PeijiSanTest
  module Initializer
    def self.load_dependencies
      require 'rubygems'
      require 'bundler'
      Bundler.require

      require 'minitest/autorun'
      require 'minitest/spec'
      require 'mocha'

      require 'active_support'
      require 'active_record'
      require 'action_view'

      $:.unshift File.expand_path('../../lib', __FILE__)
      require File.expand_path('../../init', __FILE__)
    end
    
    def self.configure_database
      ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
      ActiveRecord::Migration.verbose = false
    end
    
    def self.setup_database
      ActiveRecord::Schema.define(:version => 1) do
        create_table :members do |t|
          t.column :name, :string
          t.column :created_at, :datetime
          t.column :updated_at, :datetime
        end
        
        create_table :works do |t|
          t.column :member_id, :integer
          t.column :status, :string
        end
      end
    end
    
    def self.teardown_database
      ActiveRecord::Base.connection.tables.each do |table|
        ActiveRecord::Base.connection.drop_table(table)
      end
    end
    
    def self.start
      load_dependencies
      configure_database
    end
  end
end

PeijiSanTest::Initializer.start

class Member < ActiveRecord::Base
  extend PeijiSan
  self.entries_per_page = 10
  
  scope :all_like_krs_1, where("name LIKE 'KRS 1%'")
  scope :but_ending_with_9, where("name LIKE '%9'")
  
  has_many :works
end

class Work < ActiveRecord::Base
  extend PeijiSan
  self.entries_per_page = 5
  
  scope :uploaded, where(:status => 'uploaded')
end
