require 'test_helper'

class Scrapers::Mp::LoadTest < ActiveSupport::TestCase
  {
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
      assert_equal value, Scrapers::Mp::Load.new( { attr => value } ).run.send(attr.to_sym)
    end
  end

  def test_invalid_attribute_does_not_raise_error
    assert_nothing_raised do
      Scrapers::Mp::Load.new( { "foo" => "bar" } ).run
    end
  end

  def test_valid_party_attribute
    party = Factory(:party, :name => "Conservative")
    assert_equal party, Scrapers::Mp::Load.new( { "party" => "Conservative" } ).run.party
  end

  def test_invalid_party_attribute
    assert_nil Scrapers::Mp::Load.new( { "party" => "Foo Party" } ).run.party
  end

  def test_valid_province_attribute
    province = Factory(:province, :name => "British Columbia")
    assert_equal province, Scrapers::Mp::Load.new( { "province" => "British Columbia" } ).run.province
  end

  def test_invalid_province_attribute
    assert_nil Scrapers::Mp::Load.new( { "province" => "New Yaulk" } ).run.province
  end

  def test_already_existing_mp
    mp = Factory(:mp, :parl_gc_id => "99")

    assert_equal 1, Mp.count
    Scrapers::Mp::Load.new( { "parl_gc_id" => "99" } ).run
    assert_equal 1, Mp.count
  end

  def test_new_mp
    assert_equal 0, Mp.count
    Scrapers::Mp::Load.new( { "parl_gc_id" => "99" } ).run
    assert_equal 1, Mp.count
  end
end

