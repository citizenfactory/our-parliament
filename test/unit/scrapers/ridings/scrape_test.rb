require "test_helper"

class Scrapers::Ridings::ScrapeTest < ActiveSupport::TestCase
  context ".riding_list" do
    should "call out to the scraper classes" do
      mock_extractor = mock(:output_file => "foo")
      mock_transformer = mock

      Scrapers::Ridings::ExtractList.expects(:new).returns(mock_extractor)
      Scrapers::Ridings::TransformList.expects(:new).returns(mock_transformer)

      mock_extractor.expects(:run)
      mock_transformer.expects(:run)

      Scrapers::Ridings::Scrape.riding_list
    end
  end

  context ".ridings" do
    should "ETL for the given ridings" do
      mock_extractor = mock(:output_file => "foo")
      mock_transformer = mock
      mock_loader = mock

      Scrapers::Ridings::ExtractRiding.expects(:new).with("99", anything).returns(mock_extractor)
      Scrapers::Ridings::TransformRiding.expects(:new).with("foo").returns(mock_transformer)
      Scrapers::Ridings::LoadRiding.expects(:new).with(:some_transformed_result).returns(mock_loader)

      mock_extractor.expects(:run)
      mock_transformer.expects(:run).returns(:some_transformed_result)
      mock_loader.expects(:run).returns(stub(:errors => []))

      Scrapers::Ridings::Scrape.ridings( ["99"], stub(:puts) )
    end
  end
end
