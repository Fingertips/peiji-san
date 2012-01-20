# -*- encoding : utf-8 -*-
require File.expand_path('../test_helper', __FILE__)

describe "A model extended by PeijiSan" do
  it "should define an #entries_per_page= class method with which the max amount of entries per page is specified" do
    Member.must_respond_to :entries_per_page=
    Member.instance_variable_get(:@entries_per_page).must_equal 10
  end
  
  it "should define an #entries_per_page reader method" do
    Member.entries_per_page.must_equal 10
  end
  
  it "should have defined a #page class method and added it to the class's scopes" do
    Member.must_respond_to :page
  end
end

describe "The PeijiSan extended scope" do
  before do
    PeijiSanTest::Initializer.setup_database
    199.times { |i| Member.create(:name => "KRS #{i}") }
  end
  
  after do
    PeijiSanTest::Initializer.teardown_database
  end
  
  it "returns entries for the specified page" do
    page_1 = Member.page(1)
    page_1.length.must_equal 10
    page_1.must_equal Member.find(:all, :offset => 0, :limit => 10)
  end
  
  it "returns the correct count of pages" do
    Member.all_like_krs_1.page(1).page_count.must_equal 11
  end
  
  it "knows the current page number" do
    Member.page(2).current_page.must_equal 2
    Member.page(4).current_page.must_equal 4
  end
  
  it "knows if there's a next page" do
    Member.page(1).next_page.wont_be_nil
    Member.page(20).next_page.must_be_nil
    Member.all_like_krs_1.but_ending_with_9.page(1).next_page.must_be_nil
  end
  
  it "returns the next page number" do
    Member.page(1).next_page.must_equal 2
    Member.page(20).next_page.must_be_nil
  end
  
  it "knows if there's a previous page" do
    Member.page(1).previous_page.must_be_nil
    Member.page(20).previous_page.wont_be_nil
  end
  
  it "returns the previous page" do
    Member.page(1).previous_page.must_equal nil
    Member.page(20).previous_page.must_equal 19
  end
  
  it "knows if a given page number is the current page" do
    assert Member.page(1).current_page?(1)
    assert !Member.page(1).current_page?(2)
  end
  
  it "defaults to page 1 if no valid page argument was given" do
    Member.page(nil).current_page.must_equal 1
    Member.page('').current_page.must_equal 1
  end
  
  it "casts the page argument to an integer" do
    Member.page('2').current_page.must_equal 2
  end
  
  it "takes an optional second argument which overrides the entries_per_page setting" do
    Member.all_like_krs_1.page(1, 20).page_count.must_equal 6
  end
  
  it "returns the count of all the entries across all pages for the current scope" do
    Member.all_like_krs_1.page(1).unpaged_count.must_equal 110
    Member.all_like_krs_1.page(2).unpaged_count.must_equal 110
    Member.all_like_krs_1.but_ending_with_9.page(1).unpaged_count.must_equal 10
  end
  
  it "works when chained with other regular named scopes" do
    Member.all_like_krs_1.page(1).page_count.must_equal 11
    Member.all_like_krs_1.but_ending_with_9.page(2).page_count.must_equal 1
    
    Member.all_like_krs_1.page(2).must_equal Member.find(:all, :conditions => "name LIKE 'KRS 1%'", :offset => 10, :limit => 10)
    Member.all_like_krs_1.but_ending_with_9.page(1).must_equal Member.find(:all, :conditions => "name LIKE 'KRS 1%' AND name LIKE '%9'", :offset => 0, :limit => 10)
  end
  
  it "should still work when chained through an association proxy" do
    member = Member.first
    16.times { member.works.create(:status => 'uploaded') }
    5.times { member.works.create(:status => 'new') }
    
    page = member.reload.works.uploaded.page(1)
    page.length.must_equal 5
    page.page_count.must_equal 4
    member.works.uploaded.page(4).length.must_equal 1
    
    member.works.page(1).page_count.must_equal 5
  end
end
