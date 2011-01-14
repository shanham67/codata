require 'test_helper'

class PartyNamesControllerTest < ActionController::TestCase
  setup do
    @party_name = party_names(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:party_names)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create party_name" do
    assert_difference('PartyName.count') do
      post :create, :party_name => @party_name.attributes
    end

    assert_redirected_to party_name_path(assigns(:party_name))
  end

  test "should show party_name" do
    get :show, :id => @party_name.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @party_name.to_param
    assert_response :success
  end

  test "should update party_name" do
    put :update, :id => @party_name.to_param, :party_name => @party_name.attributes
    assert_redirected_to party_name_path(assigns(:party_name))
  end

  test "should destroy party_name" do
    assert_difference('PartyName.count', -1) do
      delete :destroy, :id => @party_name.to_param
    end

    assert_redirected_to party_names_path
  end
end
