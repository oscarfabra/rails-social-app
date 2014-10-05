require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)    
  end

  test "unsuccessful edit" do
    # Logs in a user
    log_in_as(@user)
    # Visit the edit path of given user
    get edit_user_path(@user)
    # Make an update with invalid information
    patch user_path(), user: { name: '', email: 'foo@invalid', password: 'foo',
    password_confirmation: 'bar' }
    # Check that the edit page is visited
    assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding" do
    # Visit user edit path
    get edit_user_path(@user)
    # Log in user
    log_in_as(@user)
    # Verify that user is redirected to its own edit path
    assert_redirected_to edit_user_path(@user)
    # Make an update with valid information
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name: name, email: email, password: "", 
      password_confirmation: ""}
    # Check that a flash message is shown
    assert_not flash.empty?
    # Verify that user is redirected to its show page
    assert_redirected_to @user
    # Reload values from database to check that they were successfully updated
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
end
