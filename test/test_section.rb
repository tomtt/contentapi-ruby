require 'helper'

class TestSection < Test::Unit::TestCase


  should "get a section" do
    section = GuardianContent::Section.find_by_id("books")

    assert !section.nil?
    assert_equal "books", section.id
    assert_equal "Books", section.title
    assert_equal "http://www.guardian.co.uk/books", section.url
    sleep 1
  end


  should "get a section's content" do
    section = GuardianContent::Section.find_by_id("politics")

    content = section.content
    assert_equal 10, content.size
    assert_equal "politics", content.first.section_id
  end

  should "do a section search" do
    section = GuardianContent::Section.search("design")

    assert_equal "artanddesign", section.first.id
    assert_equal "Art and design", section.first.title
  end

  should "get all sections" do
    sections = GuardianContent::Section.all

    assert_equal 38, sections.size

  end

end
