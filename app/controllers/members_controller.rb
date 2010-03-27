class MembersController < ApplicationController
  before_filter :basic_admin, :only => [:edit, :update]
  before_filter :find_mp,     :only => [:show, :edit, :update, :votes]
  
  def index
    @mps = Mp.active.all
  end
  
  def show
    @votes = Vote.last 5
  end
  
  def edit
  end
  
  def update
    @mp.update_attributes params[:mp]
    
    redirect_to member_path(@mp)
  end
  
  def votes
    @votes = Vote.all
    respond_to do |format| 
      format.rss { render } 
    end
  end
  
  private
    def find_mp
      @mp =  Mp.find(params[:id])
    end
end
