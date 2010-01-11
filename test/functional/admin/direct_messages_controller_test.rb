require 'test_helper'

class Admin::DirectMessagesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => DirectMessage.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    DirectMessage.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    DirectMessage.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to direct_message_url(assigns(:direct_message))
  end
  
  def test_edit
    get :edit, :id => DirectMessage.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    DirectMessage.any_instance.stubs(:valid?).returns(false)
    put :update, :id => DirectMessage.first
    assert_template 'edit'
  end
  
  def test_update_valid
    DirectMessage.any_instance.stubs(:valid?).returns(true)
    put :update, :id => DirectMessage.first
    assert_redirected_to direct_message_url(assigns(:direct_message))
  end
  
  def test_destroy
    direct_message = DirectMessage.first
    delete :destroy, :id => direct_message
    assert_redirected_to admin_direct_messages_url
    assert !DirectMessage.exists?(direct_message.id)
  end
end
