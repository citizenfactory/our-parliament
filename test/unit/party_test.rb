require 'test_helper'

class PartyTest < ActiveSupport::TestCase
  context ".lookup" do
    should "lookup a party by it's english name" do
      foo = Factory(:party, :name => "Foo Party")
      assert_equal foo, Party.lookup("Foo Party")
    end

    should "check party name aliases" do
      ndp = Factory(:party, :name => "New Democratic Party")
      assert_equal ndp, Party.lookup("NDP")
    end
  end
end
