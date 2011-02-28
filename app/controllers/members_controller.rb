class MembersController < ApplicationController
  before_filter :basic_admin, :only => [:edit, :update]
  before_filter :find_mp,     :only => [:show, :edit, :update, :votes, :quotes, :activity]
  before_filter :fetch_random_links, :only => [:index, :show]
  before_filter :cache_page, :only => [:index]
  
  def index
    @mps       = Mp.active.all
    @last_vote = Vote.first :order => "vote_date DESC"
  end
  
  def show
    @activity_stream = build_activity_stream
  end
  
  def edit
  end
  
  def update
    @mp.update_attributes params[:mp]
    
    redirect_to member_path(@mp)
  end
  
  def votes # not used
    @votes = Vote.all
    respond_to do |format| 
      format.rss { render } 
    end
  end
  
  def quotes # not used
    @quotes = @mp.hansard_statements
    respond_to do |format| 
      format.rss { render } 
    end
  end
  
  def activity
    @activity_stream = build_activity_stream
    respond_to do |format| 
      format.rss { render } 
    end
  end
  
  private
  
  def find_mp
      @mp =  Mp.find(params[:id])
  end
  
  def build_activity_stream
    activity_stream = ActivityStream.new

    entries = []
    votes = Vote.last 5
    votes.each { |vote|
      entries << ActivityStream::Entry.new(vote.vote_date, vote)
    }
    activity_stream.add_entries(entries)

    entries = []
    quotes = @mp.hansard_statements.first 5
    quotes.each { |quote|
      entries << ActivityStream::Entry.new(quote.time.to_date, quote)
    }
    activity_stream.add_entries(entries)

    entries = []
    tweets = @mp.tweets.first 5
    tweets.each { |tweet|
      entries << ActivityStream::Entry.new(tweet.created_at.to_date, tweet)
    }
    activity_stream.add_entries(entries)

    entries = []
    articles = @mp.news_articles.last 10
    articles.each { |article|
      entries << ActivityStream::Entry.new(article.date.to_date, article)
    }
    activity_stream.add_entries(entries)
    return activity_stream
  end
  
end
