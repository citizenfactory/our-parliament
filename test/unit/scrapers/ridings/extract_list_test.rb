require 'test_helper'

class Scrapers::Ridings::ExtractListTest < ActiveSupport::TestCase
  def test_output_file
    extractor = Scrapers::Ridings::ExtractList.new( :output_dir => "something" )
    assert_equal "something/ridings_list.html", extractor.output_file
  end

  def test_url
    url = "/MembersOfParliament/MainConstituenciesCompleteList.aspx?TimePeriod=Current&Language=E"
    assert_equal url, Scrapers::Ridings::ExtractList.new.url
  end
end
