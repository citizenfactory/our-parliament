require 'test_helper'

class Scrapers::Senators::ExtractListTest < ActiveSupport::TestCase
  def test_output_file
    extractor = Scrapers::Senators::ExtractList.new( :output_dir => "something" )
    assert_equal "something/senators_list.html", extractor.output_file
  end

  def test_url
    url = "/SenatorsMembers/Senate/SenatorsBiography/isenator.asp?Language=E"
    assert_equal url, Scrapers::Senators::ExtractList.new.url
  end
end
