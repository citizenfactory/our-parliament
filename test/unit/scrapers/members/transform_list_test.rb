require 'test_helper'

class Scrapers::Members::TransformListWithValidDataTest < ActiveSupport::TestCase
  def self.startup
    file = File.join(Rails.root, "test", "fixtures", "mp_list.html")
    transformer = Scrapers::Members::TransformList.new(file)
    @@data = transformer.run
  end

  def test_parl_gc_id
    assert_equal "170392", @@data.first
  end

  def test_member_size
    assert_equal 307, @@data.count
  end
end

class Scrapers::Members::TransformListWithValidData < ActiveSupport::TestCase
  def self.startup
    data =<<-HTML
      <table id="foo_grdCompleteList">
        <tr><td>Header</td></tr>
        <tr><td>Bad Data 1</td></tr>
        <tr><td><a href="bad_url">Foo</a></td></tr>
      </table>
    HTML

    File.stubs(:read).returns(data)
    transformer = Scrapers::Members::TransformList.new("foo.html")
    @@data = transformer.run
  end

  def test_empty_result
    assert_equal [], @@data
  end
end
