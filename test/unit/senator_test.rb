require 'test_helper'

class SenatorTest < ActiveSupport::TestCase
  def test_normalize_name
    s = Factory(:senator, :name => "Banks, Tommy")
    
    assert_equal "Banks, Tommy", s.name
    assert_equal "Tommy Banks", s.normalized_name
  end

  context "#fetch_news_articles" do
    should "search by the Senator name along with the Senator criteria" do
      senator = Senator.new(:name => "John Stewart")
      GoogleNews.expects(:search).with('John Stewart AND "Senator" location:Canada')

      senator.fetch_news_articles
    end
  end

  context "#update_news_articles" do
    should "not duplicate news article associations" do
      article_1 = Factory(:news_article)
      article_2 = Factory(:news_article)
      senator = Factory(:senator, :news_articles => [article_1])

      GoogleNews.expects(:search).returns( [article_1, article_2] )
      senator.update_news_articles

      assert_equal [article_1, article_2], senator.news_articles
    end

    should "return the new articles" do
      article_1 = Factory(:news_article)
      article_2 = Factory(:news_article)
      senator = Factory(:senator, :news_articles => [article_1])

      GoogleNews.expects(:search).returns( [article_1, article_2] )

      assert_equal [article_2], senator.update_news_articles
    end
  end
end

