require 'test_helper'

class Scrapers::Ridings::LoadRidingsAttributesTest < ActiveSupport::TestCase
  def setup
    Riding.any_instance.stubs(:save).returns(true)
  end

  def test_parl_gc_constituency_id
    assert_equal "99", Scrapers::Ridings::LoadRiding.new( { "parl_gc_constituency_id" => "99" } ).run.parl_gc_constituency_id
  end

  def test_name_en_attribute
    assert_equal "Foo", Scrapers::Ridings::LoadRiding.new( { "name_en" => "Foo" } ).run.name_en
  end

  def test_name_fr_attribute
    assert_equal "Le Foo", Scrapers::Ridings::LoadRiding.new( { "name_fr" => "Le Foo" } ).run.name_fr
  end
end

class Scrapers::Ridings::LoadRidingInteractionTest < ActiveSupport::TestCase
  def test_new_riding_record_is_created
    assert_equal 0, Riding.count
    Scrapers::Ridings::LoadRiding.new( { "parl_gc_constituency_id" => "99" } ).run
    assert_equal 1, Riding.count
  end

  def test_existing_riding_is_not_recreated
    Factory(:riding, :parl_gc_constituency_id => "99")

    assert_equal 1, Riding.count
    Scrapers::Ridings::LoadRiding.new( { "parl_gc_constituency_id" => "99" } ).run
    assert_equal 1, Riding.count
  end

  def test_existing_riding_with_no_parl_gc_constituency_id_is_not_recreated
    Factory(:riding, :name_en => "Desnethé—Missinippi—Churchill River", :parl_gc_constituency_id => nil )

    assert_equal 1, Riding.count
    Scrapers::Ridings::LoadRiding.new( { "parl_gc_constituency_id" => "99", "name_en" => "Desnethé—Missinippi—Churchill River" } ).run
    assert_equal 1, Riding.count
  end

  def test_attributes_are_updated
    Factory(:riding, :parl_gc_constituency_id => "99", :name_en => "William Henry Rutherford Smithwick III")
    riding = Scrapers::Ridings::LoadRiding.new( { "parl_gc_constituency_id" => "99", "name_en" => "Will Smithwick" } ).run
    assert_equal "Will Smithwick", riding.name_en
  end

  def test_error_logging
    Riding.any_instance.stubs(:save).returns(false)
    Riding.any_instance.stubs(:errors).returns(stub(:full_messages => "All the things I did wrong"))

    mock_logger = mock
    mock_logger.expects(:error).with("Failed to save riding: All the things I did wrong")

    Scrapers::Ridings::LoadRiding.new( { "parl_gc_constituency_id" => "99" }, :logger => mock_logger ).run
  end
end
