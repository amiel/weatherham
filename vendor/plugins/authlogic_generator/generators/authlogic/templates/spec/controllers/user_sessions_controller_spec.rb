require File.dirname(__FILE__) + '/../spec_helper'
require 'authlogic/test_case'

describe UserSessionsController do
  fixtures :users

  def valid_user_session_attributes
    @valid_user_session_attributes ||= { :login => 'klark', :password => 'superman1000' }
  end

  it 'should render the new template' do
    get :new
    response.should be_success
    response.should render_template('new')
  end
  
  it 'should create user session if valid params are given' do
    post :create, :user_session => valid_user_session_attributes
    controller.session['user_credentials'].should == users(:klark).persistence_token

    response.should be_redirect
    response.should redirect_to(account_path)
  end
  
  it 'should render login form if no valid params are given' do
    post :create, :user_session => {}
    controller.session['user_credentials'].should be_nil
  
    response.should be_success
    response.should render_template('new')
  end
end
