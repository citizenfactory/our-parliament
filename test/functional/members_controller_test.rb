require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  context "on GET to index" do
    setup do
      v = Factory(:vote)
      3.times do
        mp = Factory(:mp)
        mp.recorded_votes.create :vote => v, :stance => 'nay'
      end
      
      get :index
    end
    
    should assign_to :mps
    should assign_to :last_vote
    should respond_with :success
  end
  
  context "on GET to show" do
    setup do
      mp = Factory(:mp)
      
      get :show, :id => mp.id
    end
    
    should assign_to :activity_stream
    should respond_with :success
  end

  
  context "on GET to edit without auth" do
    setup do
      mp = Factory(:mp)
      
      get :edit, :id => mp.id
    end
    
    should respond_with 401
  end

  context "on GET to edit with auth" do
    setup do
      MembersController.any_instance.stubs(:basic_admin).returns(true)
      mp = Factory(:mp)
      
      get :edit, :id => mp.id
    end
    
    should respond_with :success
  end
  
  context "on PUT to update" do
    setup do
      MembersController.any_instance.stubs(:basic_admin).returns(true)
      @mp = Factory(:mp, :name => "before")
      
      put :update, :id => @mp.id, :mp => {:name => "after"}
    end
    
    should respond_with :redirect
    
    should "have updated the mp's name" do
      assert_equal "after", @mp.reload.name
    end
  end
  
  context "on GET to votes" do
    setup do
      @mp = Factory(:mp)
      
      get :votes, :id => @mp.id
    end
    
    should assign_to :mp
    should assign_to :votes
    should respond_with :success
    should respond_with_content_type 'application/rss+xml'
  end
end
