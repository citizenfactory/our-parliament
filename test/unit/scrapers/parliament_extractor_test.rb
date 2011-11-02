require 'test_helper'

class Scrapers::ParliamentExtractorConfigurationTest < ActiveSupport::TestCase
  def test_default_output_dir
    default_dir = File.join(Rails.root, "tmp", "data")
    assert_equal default_dir, Scrapers::ParliamentExtractor.new.output_dir
  end

  def test_output_dir_override
    assert_equal "foo", Scrapers::ParliamentExtractor.new(:output_dir => "foo").output_dir
  end

  def test_default_stale_at
    now = Time.current
    Time.stubs(:current).returns(now)
    assert_equal (now - 7.days), Scrapers::ParliamentExtractor.new.stale_at
  end

  def test_stale_file_by_time
    File.stubs(:exist?).returns(true)
    File.stubs(:mtime).returns(3.days.ago)

    extractor = Scrapers::ParliamentExtractor.new(:stale_at => 1.day.ago)
    extractor.stubs(:output_file).returns("")

    assert_equal true, extractor.stale?
  end

  def test_fresh_file
    File.stubs(:exist?).returns(true)
    File.stubs(:mtime).returns(2.days.ago)

    extractor = Scrapers::ParliamentExtractor.new
    extractor.stubs(:output_file).returns("")

    assert_equal false, extractor.stale?
  end

  def test_stale_file_by_non_existance
    File.stubs(:exist?).returns(false)

    extractor = Scrapers::ParliamentExtractor.new
    extractor.stubs(:output_file).returns("")

    assert_equal true, extractor.stale?
  end
end

class Scrapers::ParliamentExtractorRunTest < ActiveSupport::TestCase
  def setup
    File.stubs(:exist?).returns(false)
    File.stubs(:directory?).returns(true)
    FileUtils.stubs(:mkdir_p)
    Scrapers::ParliamentExtractor.any_instance.stubs(:output_file).returns("")
  end

  def test_output_dir_creation_on_run
    Net::HTTP.stubs(:start)

    File.expects(:directory?).returns(false)
    FileUtils.expects(:mkdir_p).with("foo_dir")
    Scrapers::ParliamentExtractor.new(:output_dir => "foo_dir").run
  end

  def test_not_run_on_fresh_data
    extractor = Scrapers::ParliamentExtractor.new
    extractor.expects(:stale?).returns(false)
    extractor.expects(:download_file).never

    extractor.run
  end

  def test_http_connection_with_correct_params
    Net::HTTP.expects(:start).with(Scrapers::ParliamentExtractor::HOST)
    Scrapers::ParliamentExtractor.new.run
  end

  def test_http_get_with_correct_url
    extractor = Scrapers::ParliamentExtractor.new
    extractor.expects(:url).returns("this_should_be_overridden_by_a_subclass")
    extractor.stubs(:output_file).returns("this_should_be_overridden_by_a_sublcass")

    mock_http = mock
    mock_http.expects(:get).
              with("this_should_be_overridden_by_a_subclass").
              returns(stub(:code => "200"))

    Net::HTTP.stubs(:start).yields(mock_http)
    File.stubs(:open)

    extractor.run
  end

  def test_should_save_a_file_with_the_response_data
    extractor = Scrapers::ParliamentExtractor.new
    extractor.stubs(:url).returns("this_should_be_overridden_by_a_subclass")
    extractor.expects(:output_file).at_least_once.returns("this_should_be_overridden_by_a_sublcass")

    stub_response = stub("HTTP Response", :code => "200", :body => :foo_response)
    stub_http = stub("http connection", :get => stub_response)
    Net::HTTP.stubs(:start).yields(stub_http)

    mock_file = mock
    mock_file.expects(:write).with(:foo_response)
    File.expects(:open).with("this_should_be_overridden_by_a_sublcass", "w").yields(mock_file)

    extractor.run
  end

  def test_no_file_written_if_the_response_code_is_not_200
    stub_logger = stub(:error)
    extractor = Scrapers::ParliamentExtractor.new( :logger => stub_logger )
    extractor.stubs(:url).returns("this_should_be_overridden_by_a_subclass")

    mock_response = mock(:message => anything)
    mock_response.expects(:code).at_least_once.returns("404")

    stub_http = stub("http connection", :get => mock_response)
    Net::HTTP.stubs(:start).yields(stub_http)
    File.expects(:open).never

    extractor.run
  end
end
