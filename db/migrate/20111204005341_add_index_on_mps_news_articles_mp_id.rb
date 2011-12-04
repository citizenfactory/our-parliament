class AddIndexOnMpsNewsArticlesMpId < ActiveRecord::Migration
  def self.up
    add_index :mps_news_articles, :mp_id
  end

  def self.down
    remove_index :mps_news_articles, :mp_id
  end
end
