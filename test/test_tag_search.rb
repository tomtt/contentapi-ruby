require 'helper'

class TestTagSearch < Test::Unit::TestCase
  
  should "do a search" do
    results = GuardianContent::Tag.search("cycling")
    assert_equal 5, results.size
    assert_equal "lifeandstyle/series/cycling", results.first.id
    sleep 1
  end
  
  should "do a search limited to 2" do
    results = GuardianContent::Tag.search("cycling", :limit => 2)
    assert_equal 2, results.size
    sleep 1
  end  
  
  should "do a search for a contributor" do
    results = GuardianContent::Tag.search("Brown", :conditions => {:type => :contributor})
    assert_equal "contributor", results.first.type
    sleep 1    
  end

  should "do a search for a keyword" do
    results = GuardianContent::Tag.search("Brown", :conditions => {:type => :keyword})
    assert_equal "keyword", results.first.type
    sleep 1    
  end

  should "do a search limited to a section" do
    results = GuardianContent::Tag.search("brown", :limit => 1, :conditions => {:type => :keyword, :section => :politics})
    assert_equal "politics", results.first.section_id
    sleep 1
  end
  
  should "get associated sections on a tag serch" do 
    results = GuardianContent::Tag.search("brown", :limit => 1, :conditions => {:type => :keyword, :section => :politics})
    assert_equal "Politics", results.first.section.title
    assert_equal "http://www.guardian.co.uk/politics", results.first.section.url
    sleep 1
  end    
  
end
