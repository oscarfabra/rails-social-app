require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
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
      post_via_redirect users_path, user: {name: name, email: email, 
        password: password, password_confirmation: password }
    end
    # Checks that valid submission renders show action and displays flash
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
