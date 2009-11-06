require File.dirname(__FILE__) + '/../spec_helper'
require 'authlogic/test_case'

describe UsersController do
  fixtures :users
  setup :activate_authlogic

  def valid_user_attributes
    @valid_user_attributes ||= { :login => 'kent', :password => 'superman1000', :password_confirmation => 'superman1000' }
  end

  it 'should render the new template' do
    get :new
    response.should be_success
    response.should render_template('new')
  end    
  
  it 'should create user' do
    lambda { 
      post :create, :user => valid_user_attributes
    }.should change(User, :count)

    response.should be_redirect
    response.should redirect_to(account_path)
  end
  
  it 'should render new form if creation of user fails' do
    lambda {
      post :create, :user => {}
    }.should_not change(User, :count)

    response.should be_success
    response.should render_template('new')
  end  
  
  it 'should show user if logged in' do
    UserSession.create(users(:klark))
    get :show
    response.should be_success
    response.should render_template('show')
  end
  
  it 'should redirect from show to login if not logged in' do
    get :show
    response.should be_redirect
    response.should redirect_to(login_path)
  end
  
  it 'should get edit if logged in' do
    UserSession.create(users(:klark))
    get :edit, :id => users(:klark).to_param
    response.should be_success
    response.should render_template('edit')
  end
  
  it 'should redirect from edit to login if not logged in' do
    get :edit, :id => users(:klark).to_param
    response.should be_redirect
    response.should redirect_to(login_path)
  end  
  
  it 'should update user if logged in' do
    UserSession.create(users(:klark))
    put :update, :id => users(:klark).to_param, :user => {}
    response.should be_redirect
    response.should redirect_to(account_path)
  end
  
  it 'should redirect from update to login if not logged in' do
    put :update, :id => users(:klark).to_param, :user => {}
    response.should be_redirect
    response.should redirect_to(login_path)
  end  
  
  it 'should destroy user if logged in' do
    UserSession.create(users(:klark))
    lambda {
      delete :destroy, :id => users(:klark).to_param
    }.should change(User, :count).by(-1)

    response.should be_redirect
    response.should redirect_to('/')
  end

  it 'should redirect from destroy to login if not logged in' do
    delete :destroy, :id => users(:klark).to_param
    response.should be_redirect
    response.should redirect_to(login_path)
  end  
end
