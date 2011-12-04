class RemoveDuplicateNews
  class << self
    def for_mps
      query = "DELETE FROM mps_news_articles a WHERE ctid NOT IN (
        SELECT MAX(b.ctid) FROM mps_news_articles b
        GROUP BY b.mp_id, b.news_article_id
      )"
      ActiveRecord::Base.connection.execute(query)
    end

    def for_senators
      query = "DELETE FROM senators_news_articles a WHERE ctid NOT IN (
        SELECT MAX(b.ctid) FROM senators_news_articles b
        GROUP BY b.senator_id, b.news_article_id
      )"
      ActiveRecord::Base.connection.execute(query)
    end
  end
end
