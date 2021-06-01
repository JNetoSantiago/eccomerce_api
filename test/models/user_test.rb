require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user without password must be invalid" do
    user = User.new email: 'user@email.com', password_digest: nil
    assert_not user.valid?
  end

  test "user without email must be invalid" do
    user = User.new email: nil, password_digest: '$3cret'
    assert_not user.valid?
  end

  test "user with invalid email, must have been invalid" do
    user = User.new email: 'invalid', password_digest: '$3cret'
    assert_not user.valid?
  end

  test "user valid must be valid" do
    assert_difference "User.count", 1 do
      user = User.create email: 'new_user@gmail.com', password_digest: '$3cret'
    end
  end
end
