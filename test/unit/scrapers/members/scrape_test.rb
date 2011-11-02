require 'test_helper'

class Scrapers::Members::ScrapeTest < ActiveSupport::TestCase
  def test_member_list
    mock_extractor = mock(:output_file => "foo")
    mock_transformer = mock

    Scrapers::Members::ExtractList.expects(:new).returns(mock_extractor)
    Scrapers::Members::TransformList.expects(:new).with("foo").returns(mock_transformer)

    mock_extractor.expects(:run)
    mock_transformer.expects(:run)

    Scrapers::Members::Scrape.member_list
  end

  def test_members
    mock_extractor = mock(:output_file => "foo")
    mock_transformer = mock
    mock_loader = mock

    Scrapers::Members::ExtractSummary.expects(:new).with("99", anything).returns(mock_extractor)
    Scrapers::Members::TransformSummary.expects(:new).with("foo").returns(mock_transformer)
    Scrapers::Members::LoadSummary.expects(:new).with(:some_transformed_result).returns(mock_loader)

    mock_extractor.expects(:run)
    mock_transformer.expects(:run).returns(:some_transformed_result)
    mock_loader.expects(:run).returns(stub(:errors => []))

    Scrapers::Members::Scrape.members( ["99"], stub(:puts) )
  end

  def test_disable_inactive_members
    ids = ["1", "2"]
    conditions = ["parl_gc_id NOT IN (?)", ids]

    Scrapers::Members::Scrape.expects(:member_list).returns( ids )
    Mp.expects(:count).returns(100)
    Mp.expects(:count).
      with( has_entries(:conditions => conditions) ).
      returns(1)

    Mp.expects(:update_all).with( { :active => false }, conditions )

    Scrapers::Members::Scrape.disable_inactive_members( stub(:puts) )
  end

  def test_abort_on_too_many_pending_inactive_members
    Mp.stubs(:count).returns(10).returns(4)
    Mp.expects(:update_all).never

    Scrapers::Members::Scrape.disable_inactive_members( stub(:puts) )
  end

  def test_override_abort_disable_inactive_members
    Scrapers::Members::Scrape.expects(:force?).returns(true)

    Mp.stubs(:count).returns(10).returns(4)
    Mp.expects(:update_all)

    Scrapers::Members::Scrape.disable_inactive_members( stub(:puts) )
  end
end
