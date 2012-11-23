require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success, "Home did not load"
	assert_select 'title', "TeacherMaps", "Home title not correct"
  end

end
