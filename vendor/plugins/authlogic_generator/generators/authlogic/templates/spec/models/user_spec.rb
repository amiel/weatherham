require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  it 'should act as authentic' do
    User.should include(Authlogic::ActsAsAuthentic::Base)
  end
end
