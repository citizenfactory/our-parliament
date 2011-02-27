require 'open-uri'
require 'google_news'

class Senator < ActiveRecord::Base
  index do
    name
    appointed_by
  end

  has_attached_file :image,
                    :styles      => { :medium => "120x120>", :small => "40x40>" },
                    :storage     => :s3,
                    :path        => ":attachment/:id/:style.:extension",
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
  
  class << self
    def spider_list
      # TODO: caching logic should be extracted into scraping tools
      fname = 'tmp/spidering/senator_list'
      if File.exists?(fname)
        IO.read(fname)
      else
        returning(open("http://www.parl.gc.ca/common/senmemb/senate/isenator.asp?Language=E").read) do |content|
          File.open(fname, "w") {|f| f.puts content}
        end
      end
    end
    
    def scrape_list
      rows = Nokogiri::HTML(spider_list) / "//html/body/table[3]/tr/td[2]/table/tr"
      
      rows.reject do |row|
        row.to_s !~ /isenator/
      end.collect do |row|
        scrape_senator row
      end
    end
    
    def scrape_senator(elem)
      party = Party.find_by_name_en(clean(elem / (elem.path + "/td[2]")))
      province = Province.find_by_name_en(clean(elem / (elem.path + "/td[3]")))
      new :name            => clean(elem / (elem.path + "/td[1]/a")),
          :party           => party,
          :province        => province,
          :nomination_date => clean(elem / (elem.path + "/td[4]")),
          :retirement_date => clean(elem / (elem.path + "/td[5]")),
          :appointed_by    => clean(elem / (elem.path + "/td[6]"))
    end
    
    private
    def clean(e)
      #gsub(/\302\240/, ' ') is a non-printed char that Nokogiri lets through
      e.first.inner_html.gsub(/&nbsp;/, ' ').gsub(/\302\240/, ' ').gsub(/\s+/, ' ').strip
    end
  end
end
