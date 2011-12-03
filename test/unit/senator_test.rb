require 'test_helper'

class SenatorTest < ActiveSupport::TestCase
  def test_normalize_name
    s = Factory(:senator, :name => "Banks, Tommy")
    
    assert_equal "Banks, Tommy", s.name
    assert_equal "Tommy Banks", s.normalized_name
  end
end

