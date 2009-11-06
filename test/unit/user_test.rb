require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
    test "act as authentic" do
      assert User.include?(Authlogic::ActsAsAuthentic::Base)
    end

end
