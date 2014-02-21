require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "signup" do
    get :new
    assert_response :redirect, "Signup page doesn't exist"
    assert_recognizes({ controller: 'users', action: 'new' }, signup_path, {},
      "Signup page isn't pointing to the right place")
  end
  
  test "user pages" do
    one = users(:user_one)
    get(:show, { id: "userOne" })
    assert_response :success, "Couldn't find profile page"
    assert_routing  user_path(one.account_name),
                    { controller: 'users', action: 'show', id: one.account_name }, {}, {},
                    "Profile page isn't in the right place"
  end
  
  test "create users" do
    assert_difference 'User.count', 0, "Invalid user created" do
      post  :create,
            user: {
              name:                   "John Doe",
              account_name:           "jdoe",
              email:                  "jdoe@example.com",
              password:               "foobar",
              password_confirmation:  "fooba"
            }
    end

    assert_difference 'User.count', 1, "Valid user not created" do
      post  :create,
            user: {
              name:                   "John Doe",
              account_name:           "jdoe",
              email:                  "jdoe@example.com",
              password:               "foobar",
              password_confirmation:  "foobar"
            }
    end
  end
end
