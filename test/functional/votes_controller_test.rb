require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  context "on GET to index" do
    setup do
      get :index
    end
    
    should respond_with :success
  end
end
