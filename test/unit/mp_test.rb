require 'test_helper'

class MpTest < ActiveSupport::TestCase
  should have_many :recorded_votes

  context ".similar" do
    should "return an active MP and their most recent inactive instance grouped by their similarity hash" do
      riding = Factory(:riding)
      mp_1 = Factory(:mp, :active => false, :name => "John Smith", :riding => riding, :parl_gc_id => "789")
      mp_2 = Factory(:mp, :active => true, :name => "John Smith", :riding => riding, :parl_gc_id => "456")
      mp_3 = Factory(:mp, :active => false, :name => "John Smith", :riding => riding, :parl_gc_id => "123")

      hash = Digest::MD5.hexdigest("#{mp_2.name}#{riding.id}")
      assert_equal( {hash => [mp_2, mp_1]}, Mp.similar )
    end

    should "not return anything for an MP with only an active state" do
      riding = Factory(:riding)
      mp = Factory(:mp, :active => true, :name => "John Smith", :riding => riding, :parl_gc_id => "456")

      assert_equal( {}, Mp.similar )
    end

    should "not return anything for an MP who is no longer active" do
      riding = Factory(:riding)
      mp = Factory(:mp, :active => false, :name => "John Smith", :riding => riding, :parl_gc_id => "789")

      assert_equal( {}, Mp.similar )
    end
  end

  context "#merge" do
    should "update attributes that aren't already present" do
      mp = Mp.new
      mp.merge( Mp.new("wikipedia" => "wiki foo") )

      assert_equal "wiki foo", mp.wikipedia
    end

    should "not overwrite an existing attribute" do
      mp = Mp.new(:wikipedia => "wiki foo")
      mp.merge( Mp.new("wikipedia" => "wiki bar") )

      assert_equal "wiki foo", mp.wikipedia
    end

    should "not overwrite attributes that are not user editable" do
      mp = Mp.new
      mp.merge( Mp.new("name" => "Foo") )

      assert_nil mp.name
    end
  end

  def test_link_construction
    mp = Factory(:mp)
    mp.wikipedia        = "http://en.wikipedia.org/wiki/Alan_Tonks"
    mp.wikipedia_riding = "http://en.wikipedia.org/wiki/York_South—Weston"
    mp.twitter          = "tweeter"
    mp.facebook         = "http://www.facebook.com/pages/Alan-Tonks/6334782980"

    assert mp.links.is_a?(Hash)

    assert_equal "http://en.wikipedia.org/wiki/Alan_Tonks", mp.links[I18n.t('members.weblink.wikipedia', :member_name => mp.name)]
    assert_equal "http://en.wikipedia.org/wiki/York_South—Weston", mp.links[I18n.t('members.weblink.wikipedia_riding', :member_name => mp.name)]
    assert_equal "http://twitter.com/tweeter", mp.links[I18n.t('members.weblink.twitter', :member_name => mp.name)]
    assert_equal "http://www.facebook.com/pages/Alan-Tonks/6334782980", mp.links[I18n.t('members.weblink.facebook', :member_name => mp.name)]
  end

  def test_link_returns_empty
    mp = Factory(:mp)
    mp.twitter = ''
    mp.wikipedia = ''

    assert !mp.links.keys.any?, "should not have links, but had #{mp.links.inspect}"
  end
end
