require 'test_helper'

class ProvinceTest < ActiveSupport::TestCase
  context ".lookup" do
    should "lookup a province by it's english name" do
      foo = Factory(:province, :name_en => "Foo Province")
      assert_equal foo, Province.lookup("Foo Province")
    end

    should "lookup a province by an alias" do
      pei = Factory(:province, :name_en => "Prince Edward Island")
      assert_equal pei, Province.lookup("P.E.I.")
    end
  end
end
