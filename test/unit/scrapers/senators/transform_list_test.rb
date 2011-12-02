require 'test_helper'

class Scrapers::Senators::TransformListTest < ActiveSupport::TestCase
  def valid_data
    @valid_data ||= begin
      file = File.join(Rails.root, "test", "fixtures", "senators_list.html")
      transformer = Scrapers::Senators::TransformList.new(file)
      transformer.run
    end
  end

  def invalid_data
    @invalid_data ||= begin
      html =<<-HTML
        <html>
        <body>
          <table></table>
          <table>
            <tr>
              <td>side table</td>
              <td>
                <table>
                  <tr><td>isenator but No Link</td></tr>
                </table>
              </td>
            </tr>
          </table>
        </body>
        </html>
      HTML

      File.expects(:read).returns(html)
      transformer = Scrapers::Senators::TransformList.new("")
      transformer.run
    end
  end

  context "valid data" do
    should "parse all the senators" do
      assert_equal 100, valid_data.length
    end

    should "parse the name" do
      assert_equal "Andreychuk, Raynell", valid_data.first["name"]
    end

    should "parse the party" do
      assert_equal "C", valid_data.first["party"]
    end

    should "parse the province" do
      assert_equal "Saskatchewan", valid_data.first["province"]
    end

    should "parse the nomination date" do
      assert_equal "1993-03-11", valid_data.first["nomination_date"]
    end

    should "parse the retirement date" do
      assert_equal "2019-08-14", valid_data.first["retirement_date"]
    end

    should "parse the appointed by" do
      assert_equal "Mulroney (Prog. Conser.)", valid_data.first["appointed_by"]
    end
  end

  context "invalid data" do
    [
      "name",
      "party",
      "province",
      "nomination_date",
      "retirement_date",
      "appointed_by"
    ].each do |field|
      should "set #{field} to nil when there is invalid data" do
        assert_equal true, invalid_data.first.has_key?(field)
        assert_nil invalid_data.first[field]
      end
    end
  end
end
