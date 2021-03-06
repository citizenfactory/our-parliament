require 'test_helper'

class Admin::MembersControllerTest < ActionController::TestCase
  context "on GET to index" do
    setup do
      Admin::MembersController.any_instance.stubs(:basic_admin).returns(true)
      3.times { Factory(:mp) }

      get :index
    end

    should respond_with :success
  end

  context "on GET to similar" do
    setup do
      Admin::MembersController.any_instance.stubs(:basic_admin).returns(true)
      get :similar
    end

    should render_template :index
  end
end
