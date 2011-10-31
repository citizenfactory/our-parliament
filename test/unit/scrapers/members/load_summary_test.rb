require 'test_helper'

class Scrapers::Members::LoadSummaryAttributesTest < ActiveSupport::TestCase
  def setup
    Riding.any_instance.stubs(:save).returns(true)
  end

  {
    "parl_gc_id" => "99",
    "parl_gc_constituency_id" => "10",
    "name" => "Foo Name",
    "email" => "foo@gov.ca",
    "website" => "foo.gov.ca",
    "parliamentary_phone" => "555-555-5555",
    "parliamentary_fax" => "999-999-9999",
    "preferred_language" => "English",
    "constituency_address" => "123 Liberty St",
    "constituency_city" => "Montreal",
    "constituency_postal_code" => "H2T 2S9",
    "constituency_phone" => "112-358-1321",
    "constituency_fax" => "211-385-3211"
  }.each do |attr, value|
    define_method "test_#{attr}_attribute" do
      assert_equal value, Scrapers::Members::LoadSummary.new( { attr => value } ).run.send(attr.to_sym)
    end
  end

  def test_invalid_attribute_does_not_raise_error
    assert_nothing_raised do
      Scrapers::Members::LoadSummary.new( { "foo" => "bar" } ).run
    end
  end

  def test_valid_party_attribute
    party = Factory(:party, :name => "Conservative")
    assert_equal party, Scrapers::Members::LoadSummary.new( { "party" => "Conservative" } ).run.party
  end

  def test_invalid_party_attribute
    assert_nil Scrapers::Members::LoadSummary.new( { "party" => "Foo Party" } ).run.party
  end

  def test_valid_province_attribute
    province = Factory(:province, :name => "British Columbia")
    assert_equal province, Scrapers::Members::LoadSummary.new( { "province" => "British Columbia" } ).run.province
  end

  def test_invalid_province_attribute
    assert_nil Scrapers::Members::LoadSummary.new( { "province" => "New Yaulk" } ).run.province
  end

  def test_valid_riding_attribute
    riding = Factory(:riding, :parl_gc_constituency_id => "99")
    assert_equal riding, Scrapers::Members::LoadSummary.new( { "parl_gc_constituency_id" => "99" } ).run.riding
  end

  def test_invalid_riding_attribute
    assert_nil Scrapers::Members::LoadSummary.new( { "parl_gc_constituency_id" => "fake id" } ).run.riding
  end
end

class Scrapers::Members::LoadSummaryInteractionTest < ActiveSupport::TestCase
  def test_new_mp_record_is_created
    assert_equal 0, Mp.count
    Scrapers::Members::LoadSummary.new( { "parl_gc_id" => "1" } ).run
    assert_equal 1, Mp.count
  end

  def test_existing_mp_record_is_not_recreated
    Factory(:mp, :parl_gc_id => "99")

    assert_equal 1, Mp.count
    Scrapers::Members::LoadSummary.new( { "parl_gc_id" => "99" } ).run
    assert_equal 1, Mp.count
  end

  def test_attributes_are_updated
    Factory(:mp, :parl_gc_id => "99", :name => "Shingai Shoniwa")
    mp = Scrapers::Members::LoadSummary.new( { "parl_gc_id" => "99", "name" => "Janelle Monae" } ).run
    assert_equal "Janelle Monae", mp.name
  end
end

