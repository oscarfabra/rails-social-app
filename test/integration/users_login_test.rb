require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  # Define attribute to use in the "login with valid information" test
  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    # Visit the login path
    get login_path
    # Verify that the new sessions form render properly
    assert_template 'sessions/new'
    # Post to the sessions path with an invalid params hash
    post login_path, session: {email: "", password: "" }
    # Verify that new sessions form gets re-rendered after submission
    assert_template 'sessions/new'
    # Verify that the flash message appears
    assert_not flash.empty?
    # Visit the home page
    get root_path
    # Verify that the flash message doesn't appear on the new page
    assert flash.empty?
  end

  test "login with valid information" do
    # Visit the login path
    get login_path
    #Post valid information to the sessions path
    post login_path, session: { email: @user.email, password: 'password' }
    # Check the right redirect target
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    # Verify that the login link disappears
    assert_select "a[href=?]", login_path, count: 0
    # Verify that a logout link appears
    assert_select "a[href=?]", logout_path
    # Verify that a profile link appears
    assert_select "a[href=?]", user_path(@user)
  end
end
