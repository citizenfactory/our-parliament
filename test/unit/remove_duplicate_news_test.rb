require 'test_helper'

class RemoveDuplicateNewsTest < ActiveSupport::TestCase
  context "mps" do
    should "remove duplicate MP news article associations" do
      article_1 = Factory(:news_article)
      article_2 = Factory(:news_article)
      mp_1 = Factory(:mp, :news_articles => [article_1, article_1, article_2, article_2, article_2])
      mp_2 = Factory(:mp, :news_articles => [article_1, article_1, article_1])

      assert_equal 5, mp_1.news_articles.count
      assert_equal 3, mp_2.news_articles.count
      RemoveDuplicateNews.for_mps
      assert_equal 2, mp_1.news_articles.count
      assert_equal 1, mp_2.news_articles.count
    end
  end

  context "senators" do
    should "remove duplicate Senator news article associations" do
      article_1 = Factory(:news_article)
      article_2 = Factory(:news_article)
      senator_1 = Factory(:senator, :news_articles => [article_1, article_1, article_2, article_2, article_2])
      senator_2 = Factory(:senator, :news_articles => [article_2, article_2, article_2, article_2, article_2])

      assert_equal 5, senator_1.news_articles.count
      assert_equal 5, senator_2.news_articles.count
      RemoveDuplicateNews.for_senators
      assert_equal 2, senator_1.news_articles.count
      assert_equal 1, senator_2.news_articles.count
    end
  end
end
