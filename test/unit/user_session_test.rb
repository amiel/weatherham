require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
    test "inherit from Authlogic::Session::Base" do
      assert_equal UserSession.superclass, Authlogic::Session::Base
    end

end