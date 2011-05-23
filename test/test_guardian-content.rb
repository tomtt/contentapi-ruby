require 'helper'

class TestGuardianContent < Test::Unit::TestCase

#    should "do a reload" do
#      article = GuardianContent::Content.new(:id => "world/2010/may/12/thailand-red-shirt-protesters-siege")
#      assert article.title.nil?
#      article.reload
#      assert_equal "", article.title
#    end

    should "get a keyword" do
      keyword = GuardianContent::Keyword.find_by_id("world/thailand")

      assert_equal "Thailand", keyword.title
      assert_equal "world/thailand", keyword.id
      assert_equal "http://www.guardian.co.uk/world/thailand", keyword.url
    sleep 1
    end

    should "get a contributor" do
      contributor = GuardianContent::Contributor.find_by_id("profile/charliebrooker")

      assert_equal "profile/charliebrooker", contributor.id
    sleep 1
    end

  should "get an article's associated section" do
    article = GuardianContent::Content.find_by_id("world/2010/may/12/thailand-red-shirt-protesters-siege")

    assert_equal "world", article.section_id
#    assert_equal "A", article.section.title

  sleep 1
  end



  should "get an article" do

    article = GuardianContent::Content.find_by_id("world/2010/may/12/thailand-red-shirt-protesters-siege")

    assert !article.nil?
    assert_equal "world/2010/may/12/thailand-red-shirt-protesters-siege", article.id
    assert_equal "Thai army puts off plan for siege of redshirt protesters", article.title
    assert_equal "http://www.guardian.co.uk/world/2010/may/12/thailand-red-shirt-protesters-siege", article.url
    assert_equal "2010-05-12T17:13:00+01:00", article.publication_date.to_s
    sleep 1
  end

  should "get an article's extended meta-data" do

    article = GuardianContent::Content.find_by_id("world/2010/may/12/thailand-red-shirt-protesters-siege", :select => :all)

    assert_equal "Thai army puts off plan for siege of redshirt protesters", article.headline
    assert_equal "Authorities say cutting supplies to Bangkok protesters would hit residents as government cancels plans for November election", article.fields[:standfirst]
    sleep 1
  end


  should "get an article's tags" do

    article = GuardianContent::Content.find_by_id("world/2010/may/12/thailand-red-shirt-protesters-siege", :select => :all)

    assert_equal 5, article.tags.size
    assert_equal "world/thailand", article.tags.first[:id]

    sleep 1
  end



#  should "get an article's body" do
#    article = GuardianContent::Content.find_by_id("world/2010/may/12/thailand-red-shirt-protesters-siege")

 #   assert_equal "Blah", article.body
 #sleep 1
#  end

#  should "get an article's keywords" do
#    article = GuardianContent::Content.find_by_id("world/2010/may/12/thailand-red-shirt-protesters-siege")

#    assert article.keywords.size > 0

#  end

end
