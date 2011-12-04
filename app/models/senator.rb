require 'google_news'

class Senator < ActiveRecord::Base
  index do
    name
    appointed_by
  end

  has_attached_file :image,
                    :styles      => { :medium => "120x120>", :small => "40x40>" },
                    :storage     => :s3,
                    :path        => ":rails_env/:attachment/:id/:style.:extension",
                    :bucket      => 'citizen_factory',
                    :s3_credentials => {:access_key_id => ENV["AWS_ACCESS_KEY_ID"], :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"]}

  belongs_to :province
  belongs_to :party
  has_and_belongs_to_many :news_articles, :join_table => 'senators_news_articles'

  def normalized_name
    last,first = name.split(',').collect(&:strip)
    [first, last].join(" ")
  end

  def links
    h = {}
    h[I18n.t('senators.weblink.personal', :member_name => normalized_name)]    = personal_website       unless personal_website.blank?
    h[I18n.t('senators.weblink.party', :member_name => normalized_name)]       = party_website          unless party_website.blank?
    h
  end

  def fetch_news_articles
    term = %Q{#{name} AND "Senator" location:Canada}
    GoogleNews.search(term)
  end

  def update_news_articles
    articles = fetch_news_articles
    ids = news_articles.all(
      :select => :id,
      :conditions => { :id => articles }
    ).map(&:id)

    new_articles = articles.reject { |a| ids.include?(a.id) }
    news_articles << new_articles
    save

    new_articles
  end
end
