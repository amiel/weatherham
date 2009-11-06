require 'test_helper'
require "authlogic/test_case"

class UsersControllerTest < ActionController::TestCase

  setup :activate_authlogic

  def valid_user_attributes
    @valid_user_attributes ||= { :login => 'kent', :password => 'superman1000', :password_confirmation => 'superman1000' }
  end

  test "should get new" do
    get :new
    assert_response :success
  end    
  
  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => valid_user_attributes
    end
    assert_redirected_to account_path
  end
  
  test "should render new form if creation of user fails" do
    assert_no_difference('User.count') do
      post :create, :user => {}
    end
    assert_template 'new'
  end  
  
  test "should show user if logged in" do
    UserSession.create(users(:klark))
    get :show
    assert_response :success
  end
  
  test "should redirect from show to login if not logged in" do
    get :show
    assert_redirected_to login_path
  end
  
  test "should get edit if logged in" do
    UserSession.create(users(:klark))
    get :edit, :id => users(:klark).to_param
    assert_response :success
  end
  
  test "should redirect from edit to login if not logged in" do
    get :edit, :id => users(:klark).to_param
    assert_redirected_to login_path
  end  
  
  test "should update user if logged in" do
    UserSession.create(users(:klark))
    put :update, :id => users(:klark).to_param, :user => { }
    assert_redirected_to account_path
  end
  
  test "should redirect from update to login if not logged in" do
    put :update, :id => users(:klark).to_param, :user => { }
    assert_redirected_to login_path
  end  
  
  test "should destroy user if logged in" do
    UserSession.create(users(:klark))
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:klark).to_param
    end
    assert_redirected_to '/'
  end

  test "should redirect from destroy to login if not logged in" do
    delete :destroy, :id => users(:klark).to_param
    assert_redirected_to login_path
  end  

  
end