require 'test_helper'

class Scrapers::Ridings::TransformRidingTest < ActiveSupport::TestCase
  def valid_data
    @valid_data ||= begin
      file = File.join(Rails.root, "test", "fixtures", "riding_99.html")
      transformer = Scrapers::Ridings::TransformRiding.new(file)
      transformer.run
    end
  end

  def invalid_data
    @invalid_data ||= begin
      html =<<-HTML
        <table id="foo_grdCompleteList">
          <tr><td>Header</td></tr>
          <tr><td>Bad Data 1</td></tr>
        </table>
      HTML

      File.expects(:read).returns(html)
      transformer = Scrapers::Ridings::TransformRiding.new("")
      transformer.run
    end
  end

  context "valid data" do
    should "parse the parl_gc_constituency_id from the filename" do
      assert_equal "99", valid_data["parl_gc_constituency_id"]
    end

    should "assign the english name" do
      assert_equal "Calgary—Nose Hill", valid_data["name_en"]
    end

    should "assign the french name" do
      assert_equal "Calgary—Nose Hill", valid_data["name_fr"]
    end

    should "assign the elections canada electoral district id" do
      assert_equal 48005, valid_data["electoral_district"]
    end

    should "assign the province" do
      assert_equal "Alberta", valid_data["province"]
    end

    should "remove any special characters in a province name" do
      File.stubs(:read).returns("<span id='_lblProvinceData'>Québec</span>")

      data = Scrapers::Ridings::TransformRiding.new("foo.html").run
      assert_equal "Quebec", data["province"]
    end
  end

  context "invalid data" do
    [
      "electoral_district",
      "parl_gc_constituency_id",
      "province",
      "name_en",
      "name_fr"
    ].each do |field|
      should "set #{field} to nil when there is invalid data" do
        assert_nil invalid_data[field]
      end
    end
  end
end
