# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_name    :string(255)
#  password_digest :string(255)
#  remember_token  :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup :initialize_user
  
  # Make sure our users have the necessary attributes
  test "should respond to attributes" do
    assert_respond_to @user, :name,  "User missing name."
    assert_respond_to @user, :email, "User missing email."
    assert_respond_to @user, :account_name, "User missing account_name."
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
  test "account_name must have valid format" do
    @user.account_name = " "
    assert !(@user.valid?), "User created without account_name."
    
    @user.account_name = "a" * 51
    assert !(@user.valid?), "User created with too long account_name."
    
    invalid_account_names =   %w[
                          abc
                          user@foo,com
                          user_at_foo.org
                          example.user@foo.
                          foo@bar_baz.com
                          foo@bar+baz.com
                          32r08FDSj
                        ]
    invalid_account_names.each do |invalid_account_name|
      @user.account_name = invalid_account_name
      assert !(@user.valid?), "User created with invalid account_name #{invalid_account_name}."
    end


    valid_account_names =  %w[
                        oisfoaisf
                        fadsFD24398
                        fOIoiahfd8923
                        sof92837hiuUFDS
                      ]
    valid_account_names.each do |valid_account_name|
      @user.account_name = valid_account_name
      assert @user.valid?, "User creation failed for valid account_name #{valid_account_name}."
    end
  end

  # We use email address as an identifier, so they must be unique
  test "account_names must be unique" do
    assert @user.save, "Unable to save valid user."
    
    user_with_same_account_name = @user.dup
    user_with_same_account_name.account_name = @user.account_name.upcase
    assert !(user_with_same_account_name.valid?), "User with duplicate account_name created."
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

  # Can I authenticate by account_name address?
  test "authenticate by account_name" do
    found_user = User.find_by_account_name(@user.account_name)
    
    assert found_user.authenticate(@user.password), "Can't authenticate."
    assert !found_user.authenticate(@user.password.upcase),
            "Authenticated with wrong password."
    assert !found_user.authenticate(nil), "Authenticated with nil."
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
  end
end
