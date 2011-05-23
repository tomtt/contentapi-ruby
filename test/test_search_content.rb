require 'helper'

class TestSearchContent < Test::Unit::TestCase

  should "do a search" do
    results = GuardianContent::Content.search("Gordon Brown")
    assert_equal 10, results.size
    sleep 1
  end

  should "do a search in order of relevance" do
    results = GuardianContent::Content.search("Gordon Brown", :order => :relevance)

    assert !results.first.id.nil?
    sleep 1
  end

  should "do a search in order of newest" do
    results = GuardianContent::Content.search("Gordon Brown", :order => :newest, :limit => 2)

    assert (results.first.publication_date > results.last.publication_date)
    sleep 1
  end

  should "do a search requesting 20 results" do

    results = GuardianContent::Content.search("Gordon Brown", :limit => 20)

    assert_equal 20, results.size
    sleep 1
  end

  should "do a search and select tags" do

    results = GuardianContent::Content.search("Gordon Brown", :limit => 1, :select => {:tags => :all})

    assert (results.first.tags.size > 1)

    sleep 1
  end

  should "do a search and not select tags" do

    results = GuardianContent::Content.search("Gordon Brown", :limit => 1)

    assert !results.first.tags

    sleep 1
  end

  should "do a search with a to date" do

    results = GuardianContent::Content.search("Volcano", :limit => 1, :conditions => {:to => "2010-04-28"})

    assert_equal "2010-04-28T18:59:14+01:00", results.first.publication_date.to_s
    sleep 1

  end

  should "do a search with a from date" do

    results = GuardianContent::Content.search("Election", :limit => 1, :conditions => {:from => "2010-02-01"}, :order => :oldest)

    assert_equal "2010-02-01T00:05:38+00:00", results.first.publication_date.to_s
    sleep 1

  end


end
