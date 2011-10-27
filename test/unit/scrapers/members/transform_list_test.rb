require 'test_helper'

class Scrapers::Members::TransformListTest < ActiveSupport::TestCase
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
