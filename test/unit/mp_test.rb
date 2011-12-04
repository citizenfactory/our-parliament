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

    should "not merge the upload_image_url if there's already an image" do
      mp = Mp.new
      mp.image.expects(:url).with(:original).returns("/some/image.gif")
      mp.merge( Mp.new )

      assert_nil mp.upload_image_url
    end

    should "not set the upload_image_url to the default image" do
      mp = Mp.new
      mp.merge( Mp.new )

      assert_nil mp.upload_image_url
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

  context "#fetch_news_articles" do
    should "search by the MP name along with the MP criteria" do
      mp = Mp.new(:name => "John Stewart")
      GoogleNews.expects(:search).with('John Stewart AND ("MP" OR "Member of Parliament") location:Canada')

      mp.fetch_news_articles
    end
  end

  context "#update_news_articles" do
    should "not duplicate news article associations" do
      article_1 = Factory(:news_article)
      article_2 = Factory(:news_article)
      mp = Factory(:mp, :news_articles => [article_1])

      GoogleNews.expects(:search).returns( [article_1, article_2] )
      mp.update_news_articles

      assert_equal [article_1, article_2], mp.news_articles
    end

    should "return the new articles" do
      article_1 = Factory(:news_article)
      article_2 = Factory(:news_article)
      mp = Factory(:mp, :news_articles => [article_1])

      GoogleNews.expects(:search).returns( [article_1, article_2] )

      assert_equal [article_2], mp.update_news_articles
    end
  end
end
