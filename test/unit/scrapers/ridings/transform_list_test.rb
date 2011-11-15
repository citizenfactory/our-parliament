require 'test_helper'

class Scrapers::Ridings::TransformListTest < ActiveSupport::TestCase
  def self.startup
    file = File.join(Rails.root, "test", "fixtures", "ridings_list.html")
    transformer = Scrapers::Ridings::TransformList.new(file)
    @@data = transformer.run
  end

  def test_ridings_count
    assert_equal 308, @@data.length
  end

  def test_parl_gc_constituency_id
    assert_equal "538", @@data.first
  end

  def test_invalid_data
    data =<<-HTML
      <table id="foo_grdCompleteList">
        <tr><td>Header</td></tr>
        <tr><td>Bad Data 1</td></tr>
      </table>
    HTML

    File.expects(:read).returns(data)
    transformer = Scrapers::Ridings::TransformList.new(anything)
    assert_equal [], transformer.run
  end
end
