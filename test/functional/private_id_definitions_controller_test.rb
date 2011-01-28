require 'test_helper'

class PrivateIdDefinitionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => PrivateIdDefinition.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    PrivateIdDefinition.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    PrivateIdDefinition.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to private_id_definition_url(assigns(:private_id_definition))
  end

  def test_edit
    get :edit, :id => PrivateIdDefinition.first
    assert_template 'edit'
  end

  def test_update_invalid
    PrivateIdDefinition.any_instance.stubs(:valid?).returns(false)
    put :update, :id => PrivateIdDefinition.first
    assert_template 'edit'
  end

  def test_update_valid
    PrivateIdDefinition.any_instance.stubs(:valid?).returns(true)
    put :update, :id => PrivateIdDefinition.first
    assert_redirected_to private_id_definition_url(assigns(:private_id_definition))
  end

  def test_destroy
    private_id_definition = PrivateIdDefinition.first
    delete :destroy, :id => private_id_definition
    assert_redirected_to private_id_definitions_url
    assert !PrivateIdDefinition.exists?(private_id_definition.id)
  end
end
