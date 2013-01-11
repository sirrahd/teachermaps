require 'test_helper'

class DropBoxAccountsControllerTest < ActionController::TestCase
  setup do
    @drop_box_account = drop_box_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:drop_box_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create drop_box_account" do
    assert_difference('DropBoxAccount.count') do
      post :create, drop_box_account: {  }
    end

    assert_redirected_to drop_box_account_path(assigns(:drop_box_account))
  end

  test "should show drop_box_account" do
    get :show, id: @drop_box_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @drop_box_account
    assert_response :success
  end

  test "should update drop_box_account" do
    put :update, id: @drop_box_account, drop_box_account: {  }
    assert_redirected_to drop_box_account_path(assigns(:drop_box_account))
  end

  test "should destroy drop_box_account" do
    assert_difference('DropBoxAccount.count', -1) do
      delete :destroy, id: @drop_box_account
    end

    assert_redirected_to drop_box_accounts_path
  end
end
