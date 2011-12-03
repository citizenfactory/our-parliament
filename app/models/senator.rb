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
    articles = []
    articles = GoogleNews.search(name + ' AND "Senator" location:Canada')
    return articles
  end
end
