require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

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
end
