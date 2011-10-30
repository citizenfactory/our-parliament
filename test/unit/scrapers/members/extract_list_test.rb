require 'test_helper'

class Scrapers::Members::ExtractListTest < ActiveSupport::TestCase
  def test_output_file
    extractor = Scrapers::Members::ExtractList.new( :output_dir => "something" )
    assert_equal "something/mp_list.html", extractor.output_file
  end

  def test_url
    url = "/MembersOfParliament/MainMPsCompleteList.aspx?TimePeriod=Current&Language=E"
    assert_equal url, Scrapers::Members::ExtractList.new.url
  end
end
