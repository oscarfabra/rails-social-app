require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)    
  end

  test "password_reset" do
    # Visit retrieve password page
    get new_password_reset_path
    # Perform invalid submission
    post password_resets_path, password_reset: { email: "" }
    assert_template 'password_resets/new'
    # Perform valid submission
    post password_resets_path, password_reset: { email: @user.email }
    assert_redirected_to root_url
    # Get the user from the create action.
    user = assigns(:user)
    follow_redirect!
    assert_select 'div.alert'
    assert_equal 1, ActionMailer::Base.deliveries.size
    # Wrong email on edit path
    get edit_password_reset_path(user.reset_token, email: 'wrong')
    assert_redirected_to root_url
    # Right email, wrong token on edit path
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Right email, right token on edit path
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input#email[name=email][type=hidden][value=?]", user.email
    # Invalid password & confirmation
    patch password_reset_path(user.reset_token), 
    email: user.email, 
    user: 
    { 
        password: "foobarbaz", 
        password_confirmation: "barquuoux" 
    }
    assert_select 'div#error_explanation'
    # Blank password & confirmation
    patch password_reset_path(user.reset_token), 
    email: user.email, 
    user:
    { 
        password: "", 
        password_confirmation: ""
    }
    assert_not_nil flash.now
    assert_template 'password_resets/edit'
    # Valid password & confirmation
    patch_via_redirect password_reset_path(user.reset_token), 
    email: user.email, 
    user: 
    { 
        password: "foobarbaz", 
        password_confirmation: "foobarbaz"
    }
    assert_template 'users/show'
  end

  test "expired token" do
    # Visit retrieve password page
    get new_password_reset_path
    # Perform a valid submission
    post password_resets_path, password_reset: { email: @user.email }
    # Get the user from the create action
    @user = assigns(:user)
    # Update reset_sent_at user's attribute to 25 hours ago
    @user.update_attribute(:reset_sent_at, 25.hours.ago)
    patch password_reset_path(@user.reset_token), 
    email: @user.email, 
    user:
    {
        password: "foobarbaz",
        password_confirmation: "foobarbaz"
    }
    # Verify that user is redirected to other page
    assert_response :redirect
    follow_redirect!
    # Verify that the page contains the word "expired"
    assert_match /Expired|expired/i, response.body
  end
end
