require 'test_helper'

class Scrapers::Members::ExtractSummaryTest < ActiveSupport::TestCase
  def test_output_file
    extractor = Scrapers::Members::ExtractSummary.new( "99", :output_dir => "something" )
    assert_equal "something/mp_99.html", extractor.output_file
  end

  def test_url
    url = "/MembersOfParliament/ProfileMP.aspx?Language=E&Key=99"
    assert_equal url, Scrapers::Members::ExtractSummary.new("99").url
  end
end
