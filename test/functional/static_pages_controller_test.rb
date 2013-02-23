require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :redirect, "  "
  end

  test "should get help" do
    get :help
    assert_response :success, "Help did not load"
  end
  
  test "should get about" do
    get :about
    assert_response :success, "About did not load"
  end

end
