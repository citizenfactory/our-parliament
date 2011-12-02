require 'test_helper'

class Scrapers::Senators::ScrapeTest < ActiveSupport::TestCase
  context ".senator_list" do
    should "return list list of transformed senator objects" do
      mock_extractor = mock(:output_file => "foo")
      mock_transformer = mock

      Scrapers::Senators::ExtractList.expects(:new).returns(mock_extractor)
      Scrapers::Senators::TransformList.expects(:new).with("foo").returns(mock_transformer)

      mock_extractor.expects(:run)
      mock_transformer.expects(:run).returns(:some_transformed_result)

      assert_equal :some_transformed_result, Scrapers::Senators::Scrape.senator_list
    end
  end

  context ".senators" do
    should "call out to the right classes" do
      mock_loader = mock
      stub_transformed_result = stub(:[] => {"name" => "foo"})

      Scrapers::Senators::LoadSenator.expects(:new).with(stub_transformed_result).returns(mock_loader)
      mock_loader.expects(:run).returns(stub(:errors => []))

      Scrapers::Senators::Scrape.senators( [stub_transformed_result], stub(:puts) )
    end
  end

  context ".delete_inactive_senators" do
    should "call out to the right classed" do
      conditions = ["name NOT IN (?)", ["John Doe", "Jane Doe"]]

      Scrapers::Senators::Scrape.expects(:senator_list).returns( [{"name" => "John Doe"}, {"name" => "Jane Doe"}] )
      Senator.expects(:delete_all).with(conditions)

      Scrapers::Senators::Scrape.delete_inactive_senators
    end
  end
end
