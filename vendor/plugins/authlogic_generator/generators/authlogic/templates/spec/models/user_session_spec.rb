require File.dirname(__FILE__) + '/../spec_helper'

describe UserSession do
  it 'should inherit from Authlogic::Session::Base' do
    UserSession.superclass.should == Authlogic::Session::Base
  end
end
