require 'test_helper'

class SenatorsControllerTest < ActionController::TestCase
  context "on GET to index" do
    setup do
      3.times { Factory(:senator) }
      
      get :index
    end
    
    should assign_to :senators
    should respond_with :success
  end
  
  context "on GET to show" do
    setup do
      senator = Factory(:senator)
      5.times { Factory(:link, :category => 'glossary')}
      5.times { Factory(:link, :category => 'article')}
      
      get :show, :id => senator.id
    end
    
    should assign_to :senator
    should assign_to :article_links
    should assign_to :glossary_links
    should respond_with :success
  end
  
  context "on GET to edit without auth" do
    setup do
      senator = Factory(:senator)
      
      get :edit, :id => senator.id
    end
    
    should respond_with 401
  end

  context "on GET to edit with auth" do
    setup do
      SenatorsController.any_instance.stubs(:basic_admin).returns(true)
      senator = Factory(:senator)
      
      get :edit, :id => senator.id
    end
    
    should respond_with :success
  end
  
  context "on PUT to update" do
    setup do
      SenatorsController.any_instance.stubs(:basic_admin).returns(true)
      @senator = Factory(:senator, :name => "before")
      
      put :update, :id => @senator.id, :senator => {:name => "after"}
    end
    
    should respond_with :redirect
    
    should "have updated the senator's name" do
      assert_equal "after", @senator.reload.name
    end
  end
end
