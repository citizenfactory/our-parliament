require "test_helper"

class Scrapers::Ridings::ExtractRidingTest < ActiveSupport::TestCase
  def test_output_file
    extractor = Scrapers::Ridings::ExtractRiding.new( "99", :output_dir => "something" )
    assert_equal "something/riding_99.html", extractor.output_file
  end

  def test_url
    url = "/MembersOfParliament/ProfileConstituency.aspx?Language=E&Key=99"
    assert_equal url, Scrapers::Ridings::ExtractRiding.new("99").url
  end
end
