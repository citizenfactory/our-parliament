require 'test_helper'

class Scrapers::Mp::TransformWithValidDataTest < ActiveSupport::TestCase
  def self.startup
    file = File.join(Rails.root, "test", "fixtures", "mp_99.html")
    transformer = Scrapers::Mp::Transform.new(file)
    @@data = transformer.run
  end

  def test_parl_gc_id
    assert_equal "99", @@data["parl_gc_id"]
  end

  def test_parl_gc_constituency_id
    assert_equal 488, @@data["parl_gc_constituency_id"]
  end

  def test_party
    assert_equal "Conservative", @@data["party"]
  end

  def test_name
    assert_equal "Mark Adler", @@data["name"]
  end

  def test_email
    assert_equal "Mark.Adler@parl.gc.ca", @@data["email"]
  end

  def test_website
    assert_equal "http://www.pm.gc.ca/", @@data["website"]
  end

  def test_parliamentary_phone
    assert_equal "613-941-6339", @@data["parliamentary_phone"]
  end

  def test_parliamentary_fax
    assert_equal "613-941-2421", @@data["parliamentary_fax"]
  end

  def test_preferred_language
    assert_equal "English", @@data["preferred_language"]
  end

  def test_constituency_address
    assert_equal "638A Sheppard Avenue West, Suite 210", @@data["constituency_address"]
  end

  def test_constituency_city
    assert_equal "Toronto", @@data["constituency_city"]
  end

  def test_constituency_postal_code
    assert_equal "M3H 2S1", @@data["constituency_postal_code"]
  end

  def test_constituency_phone
    assert_equal "416-638-3700", @@data["constituency_phone"]
  end

  def test_constituency_fax
    assert_equal "416-638-1407", @@data["constituency_fax"]
  end
end

class Scrapers::Mp::TransformWithInvalidDataTest < ActiveSupport::TestCase
  def self.startup
    File.stubs(:read).returns("<html><body>Random HTML</body></html>")
    transformer = Scrapers::Mp::Transform.new("foo.html")
    @@data = transformer.run
  end

  [
    "parl_gc_id",
    "parl_gc_constituency_id",
    "party",
    "name",
    "email",
    "website",
    "parliamentary_phone",
    "parliamentary_fax",
    "preferred_language",
    "constituency_address",
    "constituency_city",
    "constituency_postal_code",
    "constituency_phone",
    "constituency_fax"
  ].each do |field|
    define_method("test_#{field}_is_nil") do
      assert_nil @@data[field]
    end
  end
end

