class VotesController < ApplicationController
  before_filter :cache_page, :only => [:index]
  before_filter :fetch_random_links, :only => [:index, :show]
  
  def index
    @votes = Vote.all(:order => "vote_date DESC")
  end
  
  def show
    @vote = Vote.find_by_id(params[:id])
    @votes_by_party = @vote.total_votes_by_party
    @parties = Party.find_all_by_id(@votes_by_party.keys, :order => "name_en ASC")
    @parties.each { |party|
      if party.name_en == "Independent"
        @parties.delete(party)
        @parties.push(party)
      end
    }
  end
  
end
