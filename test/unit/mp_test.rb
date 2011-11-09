require 'test_helper'

class MpTest < ActiveSupport::TestCase
  should have_many :recorded_votes

  def test_similar_scope
    riding = Factory(:riding)
    mp_1 = Factory(:mp, :active => false, :name => "John Smith", :riding => riding, :parl_gc_id => "789")
    mp_2 = Factory(:mp, :active => true, :name => "John Smith", :riding => riding, :parl_gc_id => "456")
    mp_3 = Factory(:mp, :active => false, :name => "John Smith", :riding => riding, :parl_gc_id => "123")
    Factory(:mp) # Another random MP

    assert_equal [mp_2, mp_1], Mp.similar
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
