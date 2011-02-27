class SenatorsController < ApplicationController
  before_filter :basic_admin, :only => [:edit, :update]
  before_filter :find_senator, :except => [:index]
  before_filter :cache_page, :only => [:index]
  before_filter :fetch_random_links, :only => [:index, :show]
  
  def index
    @senators = Senator.all
  end
  
  def show
    @activity_stream = build_activity_stream
  end
  
  def edit
  end
  
  def activity
    @activity_stream = build_activity_stream
    respond_to do |format| 
      format.rss { render } 
    end
  end
  
  def update
    @senator.update_attributes params[:senator]
    
    redirect_to senator_path(@senator)
  end
  
  def build_activity_stream
    activity_stream = ActivityStream.new
    entries = []
    articles = @senator.news_articles.last 10
    articles.each { |article|
      entries << ActivityStream::Entry.new(article.date.to_date, article)
    }
    activity_stream.add_entries(entries)
    return activity_stream
  end
  
  private
    def find_senator
      @senator = Senator.find params[:id]
    end
end
