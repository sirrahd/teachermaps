require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup :initialize_user
  
  # Make sure our users have the necessary attributes
  test "should respond to attributes" do
    assert_respond_to @map,  :name,  "Map missing name."
    assert_respond_to @map, :slug,  "Map missing slug."
    assert_respond_to @map,  :user,  "Map missing user."

    
  end
  
  # Basic checks for name existence and length
  test "name must have valid format" do
    @map.name = nil
    assert !(@map.valid?), "Map created without name."

    @map.name = "a"
    assert !(@map.valid?), "Map created with invalid name."

    @map.name = "a "
    assert !(@map.valid?), "Map created with invalid name."

    @map.name = " a"
    assert !(@map.valid?), "Map created with invalid name."

    @map.name = "\ta"
    assert !(@map.valid?), "Map created with invalid name."

    @map.name = "a\t"
    assert !(@map.valid?), "Map created with invalid name."

    @map.name = "a"*251
    assert !(@map.valid?), "Map created with to long of a name."
    
    @map.name = "a"*2
    assert @map.valid?, "Map not created with valid name."

    @map.name = "a"*3
    assert @map.valid?, "Map not created with valid name."

    @map.name = "a"*250
    assert @map.valid?, "Map not created with valid name."
  end
  
  
  private
  
  def initialize_user

    @user = User.new  name: "Example User", 
                      email: "user@example.org",
                      account_name: "example",
                      password: "foobar",
                      password_confirmation: "foobar"
                      
    assert @user.valid?, "Initialized user was not valid."
    assert @user.save, "Unable to save valid user."


    @map = Map.new name: 'Map Unit Test'
    @map.user = @user             


    assert @map.valid?, "Initialized map was not valid."
    assert @map.save, "Unable to save valid map." 
  end
end
