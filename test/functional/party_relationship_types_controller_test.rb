require 'test_helper'

class PartyRelationshipTypesControllerTest < ActionController::TestCase
  setup do
    @party_relationship_type = party_relationship_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:party_relationship_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create party_relationship_type" do
    assert_difference('PartyRelationshipType.count') do
      post :create, :party_relationship_type => @party_relationship_type.attributes
    end

    assert_redirected_to party_relationship_type_path(assigns(:party_relationship_type))
  end

  test "should show party_relationship_type" do
    get :show, :id => @party_relationship_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @party_relationship_type.to_param
    assert_response :success
  end

  test "should update party_relationship_type" do
    put :update, :id => @party_relationship_type.to_param, :party_relationship_type => @party_relationship_type.attributes
    assert_redirected_to party_relationship_type_path(assigns(:party_relationship_type))
  end

  test "should destroy party_relationship_type" do
    assert_difference('PartyRelationshipType.count', -1) do
      delete :destroy, :id => @party_relationship_type.to_param
    end

    assert_redirected_to party_relationship_types_path
  end
end
