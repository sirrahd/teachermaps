# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  alias      :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup :initialize_user
  
  # Make sure our users have the necessary attributes
  test "should respond to attributes" do
    assert_respond_to @user, :name,  "User missing name."
    assert_respond_to @user, :email, "User missing email."
    assert_respond_to @user, :alias, "User missing alias."
    assert_respond_to @user, :password_digest, "User missing password digest."
    assert_respond_to @user, :password, "User missing password."
    assert_respond_to @user, :password_confirmation, "User missing confirmation."
    end
  
  # Basic checks for name existence and length
  test "name must have valid format" do
    @user.name = " "
    assert !(@user.valid?), "User created without name."
    
    @user.name = "a" * 51
    assert !(@user.valid?), "User created with too long name."
  end
  
  # Basic checks for email existence and format
  test "email must have valid format" do
    @user.email = " "
    assert !(@user.valid?), "User created without email."
    
    @user.email = "a" * 51
    assert !(@user.valid?), "User created with too long email."
    
    invalid_emails =  %w[
                          user@foo,com
                          user_at_foo.org
                          example.user@foo.
                          foo@bar_baz.com
                          foo@bar+baz.com
                        ]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert !(@user.valid?), "User created with invalid email #{invalid_email}."
    end
    
    valid_emails =  %w[
                        user@foo.COM
                        A_US-ER@f.b.org
                        frst.last@foo.jp
                        a+b@baz.cn
                      ]
    valid_emails.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "User creation failed for valid email #{valid_email}."
    end
  end

  # We use email address as an identifier, so they must be unique
  test "email addresses must be unique" do    
    user_with_same_email = @user.dup
    user_with_same_email.email = @user.email.upcase
    assert !(user_with_same_email.valid?), "User with duplicate email created."
  end

  # Basic checks for email existence and format
  test "alias must have valid format" do
    @user.alias = " "
    assert !(@user.valid?), "User created without alias."
    
    @user.alias = "a" * 51
    assert !(@user.valid?), "User created with too long alias."
    
    invalid_aliases =   %w[
                          abc
                          user@foo,com
                          user_at_foo.org
                          example.user@foo.
                          foo@bar_baz.com
                          foo@bar+baz.com
                          32r08FDSj
                        ]
    invalid_aliases.each do |invalid_alias|
      @user.alias = invalid_alias
      assert !(@user.valid?), "User created with invalid alias #{invalid_alias}."
    end
    
    valid_aliases =  %w[
                        oisfoaisf
                        fadsFD24398
                        fOIoiahfd8923
                        sof92837hiuUFDS
                      ]
    valid_aliases.each do |valid_alias|
      @user.alias = valid_alias
      assert @user.valid?, "User creation failed for valid alias #{valid_alias}."
    end
  end

  # We use email address as an identifier, so they must be unique
  test "aliases must be unique" do
    assert @user.save, "Unable to save valid user."
    
    user_with_same_alias = @user.dup
    user_with_same_alias.alias = @user.alias.upcase
    assert !(user_with_same_alias.valid?), "User with duplicate alias created."
  end
  
  # Password checks for existence and matching
  test "passwords must exist and match" do
    @user.password = "      "
    assert !(@user.valid?), "User created with blank password."
    
    @user.password = "abc"
    assert !(@user.valid?), "User created with too short password."
    
    @user.password = "foobar"
    @user.password_confirmation = ""
    assert !(@user.valid?), "User created with blank confirmation."
    
    @user.password_confirmation = "raboof"
    assert !(@user.valid?), "User created with password mismatch."
    
    @user.password_confirmation = nil
    assert !(@user.valid?), "User created with nil confirmation."
  end
  
  # Can I authenticate by email address?
  test "authenticate by email" do
    found_user = User.find_by_email(@user.email)
    
    assert found_user.authenticate(@user.password), "Can't authenticate."
    assert !found_user.authenticate(@user.password.upcase),
            "Authenticated with wrong password."
    assert !found_user.authenticate(nil), "Authenticated with nil."
  end

  # Can I authenticate by alias address?
  test "authenticate by alias" do
    found_user = User.find_by_alias(@user.alias)
    
    assert found_user.authenticate(@user.password), "Can't authenticate."
    assert !found_user.authenticate(@user.password.upcase),
            "Authenticated with wrong password."
    assert !found_user.authenticate(nil), "Authenticated with nil."
  end  
  
  private
  
  def initialize_user
    @user = User.new  name: "Example User", 
                      email: "user@example.org",
                      alias: "example",
                      password: "foobar",
                      password_confirmation: "foobar"
                      
    assert @user.valid?, "Initialized user was not valid."
    assert @user.save, "Unable to save valid user."
  end
end
