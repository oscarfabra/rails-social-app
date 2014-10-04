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

  test "login with valid information followed by logout" do
    # Visit the login path
    get login_path
    #Post valid information to the sessions path
    post login_path, session: { email: @user.email, password: 'password' }
    # Check that user is logged in
    assert is_logged_in?
    # Check the right redirect target
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    # Verify that all login links disappear
    assert_select "a[href=?]", login_path, count: 0
    # Verify that a logout link appears
    assert_select "a[href=?]", logout_path
    # Verify that a profile link appears
    assert_select "a[href=?]", user_path(@user)
    # Verify that user is logged out
    delete logout_path
    assert_not is_logged_in?
    # Verify that user is redirected to root url
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window
    delete logout_path
    # Visit root url
    follow_redirect!
    # Verify that a login link appears
    assert_select "a[href=?]", login_path
    # Verify that all logout link disappear
    assert_select "a[href=?]", logout_path, count: 0
    # Verify that all profile links disappear
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "login with remembering" do
    # Calls helper method if options hash
    log_in_as(@user, remember_me: '1')
    # Checks that remember token is set in the cookies
    assert_equal assigns(:user).remember_token, cookies['remember_token']
  end

  test "login without remembering" do
    # Calls helper method if options hash
    log_in_as(@user, remember_me: '0')
    # Checks that remember token isn't set in the cookies
    assert_nil cookies['remember_token']
  end
end
