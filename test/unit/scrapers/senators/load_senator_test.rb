require 'test_helper'

class Scrapers::Senators::LoadSenatorTest < ActiveSupport::TestCase
  def setup
    Senator.any_instance.stubs(:save).returns(true)
  end

  context "attributes" do
    should "not raise an error if you give it an invalid attribute" do
      assert_nothing_raised do
        Scrapers::Senators::LoadSenator.new( { "foo" => "bar" } ).run
      end
    end

    should "assign the name" do
      assert_equal "John Doe", Scrapers::Senators::LoadSenator.new( { "name" => "John Doe" } ).run.name
    end

    should "assign the party" do
      party = Factory(:party, :name => "Conservative")
      assert_equal party, Scrapers::Senators::LoadSenator.new( { "party" => "C" } ).run.party
    end

    should "assign the province" do
      province = Factory(:province, :name => "British Columbia")
      assert_equal province, Scrapers::Senators::LoadSenator.new( { "province" => "B.C." } ).run.province
    end

    should "assign the nomination date" do
      date = Date.parse("1993-03-11")
      assert_equal date, Scrapers::Senators::LoadSenator.new( { "nomination_date" => "1993-03-11" } ).run.nomination_date
    end

    should "assign the retirement date" do
      date = Date.parse("2020-03-11")
      assert_equal date, Scrapers::Senators::LoadSenator.new( { "retirement_date" => "2020-03-11" } ).run.retirement_date
    end

    should "assign the appointed by name" do
      assert_equal "Yogi Bear", Scrapers::Senators::LoadSenator.new( {"appointed_by" => "Yogi Bear" } ).run.appointed_by
    end
  end
end

class Scrapers::Senators::LoadSenatorInteractionTest < ActiveSupport::TestCase
  should "create a new senator when their name doesn't already exist in the database" do
    assert_equal 0, Senator.count
    Scrapers::Senators::LoadSenator.new( { "name" => "Shingai Shoniwa" } ).run
    assert_equal 1, Senator.count
  end

  should "not create a senator if their name already exists in the database" do
    Factory(:senator, :name => "Don Cherry")

    assert_equal 1, Senator.count
    Scrapers::Senators::LoadSenator.new( { "name" => "Don Cherry" } ).run
    assert_equal 1, Senator.count
  end

  should "update an existing senator with any new attributes" do
    Factory(:senator, :name => "Blue Rodeo", :retirement_date => Date.parse("2020-01-01"))

    senator = Scrapers::Senators::LoadSenator.new( { "name" => "Blue Rodeo", "retirement_date" => "2050-01-01" } ).run
    senator.reload

    assert_equal Date.parse("2050-01-01"), senator.retirement_date
  end
end
