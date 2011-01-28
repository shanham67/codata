require 'test_helper'

class PhoneNumbersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => PhoneNumber.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    PhoneNumber.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    PhoneNumber.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to phone_number_url(assigns(:phone_number))
  end

  def test_edit
    get :edit, :id => PhoneNumber.first
    assert_template 'edit'
  end

  def test_update_invalid
    PhoneNumber.any_instance.stubs(:valid?).returns(false)
    put :update, :id => PhoneNumber.first
    assert_template 'edit'
  end

  def test_update_valid
    PhoneNumber.any_instance.stubs(:valid?).returns(true)
    put :update, :id => PhoneNumber.first
    assert_redirected_to phone_number_url(assigns(:phone_number))
  end

  def test_destroy
    phone_number = PhoneNumber.first
    delete :destroy, :id => phone_number
    assert_redirected_to phone_numbers_url
    assert !PhoneNumber.exists?(phone_number.id)
  end
end
