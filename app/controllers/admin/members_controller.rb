class Admin::MembersController < ApplicationController
  before_filter :basic_admin

  def index
    @mps = Mp.active.all(:order => "name")
  end

  def similar
    @mps = Mp.similar.collect do |_, (active, inactive)|
      active.merge_user_editable_attributes(inactive.attributes)
      active
    end

    render :action => :index
  end

  def update
    flash[:notice] = "mp information updated!"

    params[:mps].each do |mpid, attributes|
      Mp.find(mpid).update_attributes(attributes)
    end

    redirect_to admin_members_url
  end
end
