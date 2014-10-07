require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear    
  end
  
  # Verifies that no user is signed up when invalid info is posted
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "", email: "user@invalid", 
        password: "foo", password_confirmation: "bar" }
    end
    # Checks that a failed submission renders new action and displays errors
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  # Checks that a correct signup creates a new user
  test "valid signup information" do
    get signup_path
    name = "Example User"
    email = "user@example.com"
    password = "foobarbaz"
    assert_difference 'User.count', 1 do
      post users_path, user: {name: name, email: email, 
        password: password, password_confirmation: password }
    end
    # Verify that exactly one message is delivered
    assert_equal 1, ActionMailer::Base.deliveries.size
    # Access @user variable from Users controller's create action
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation and verify that user is not logged in
    log_in_as(user)
    assert_not is_logged_in?
    # Send invalid activation token and verify user is not logged in
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Valid token, wrong email. Verify user is not logged in.
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token.
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    # Checks that show action is rendered
    assert_template 'users/show'
    assert_not flash.empty?
    # Checks that user has been logged in
    assert is_logged_in?
  end
end
