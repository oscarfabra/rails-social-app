require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com", 
      password: "foobarbaz", password_confirmation: "foobarbaz")
  end

  test "should be valid" do
    assert @user.valid?
  end

  # If @user.name = "" then @user.valid? should return false
  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  # If @user.length is > 50 then @user.valid? should return false
  test "name shouldn't be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  # Verifies that rare but valid email addresses are accepted
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?
    end
  end

  # Verifies that invalid email addresses are not accepted
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?
    end
  end

  # Verifies that two emails with same chars but different cases are treated as
  # distinct emails
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPLE.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 7
    assert_not @user.valid?
  end

  test "associated microposts should be destroyed" do
    @user.save
    # Create a micropost
    @user.microposts.create!(content: "Lorem ipsum")
    # Verify there's 1 less micropost when user destroyed
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end
end
