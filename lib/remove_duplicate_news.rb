class RemoveDuplicateNews
  class << self
    def for_mps
      Mp.all.each do |mp|
        puts "Cleaning MP: #{mp.name}"
        query = "DELETE FROM mps_news_articles a WHERE a.mp_id = #{mp.id} AND a.ctid NOT IN (
          SELECT MAX(b.ctid) FROM mps_news_articles b
          WHERE b.mp_id = #{mp.id}
          GROUP BY b.mp_id, b.news_article_id
        )"
        ActiveRecord::Base.connection.execute(query)
      end
    end

    def for_senators
      Senator.all.each do |senator|
        puts "Cleaning Senator: #{senator.name}"
        query = "DELETE FROM senators_news_articles a WHERE a.senator_id = #{senator.id} AND a.ctid NOT IN (
          SELECT MAX(b.ctid) FROM senators_news_articles b
          WHERE b.senator_id = #{senator.id}
          GROUP BY b.senator_id, b.news_article_id
        )"
        ActiveRecord::Base.connection.execute(query)
      end
    end
  end
end
